import argparse
import json
import tempfile
import time
import zipfile
from pathlib import Path

import numpy as np
import robosuite as suite
from stable_baselines3 import A2C, PPO, SAC, TD3

MODEL_CLASSES = {
    "PPO": PPO,
    "A2C": A2C,
    "SAC": SAC,
    "TD3": TD3,
}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--bundle", required=True)
    parser.add_argument("--mode", choices=["gui", "video"], default="gui")
    parser.add_argument("--fps", type=int, default=60)
    parser.add_argument("--deterministic", action="store_true")
    args = parser.parse_args()

    bundle_path = Path(args.bundle)

    with tempfile.TemporaryDirectory() as tmpdir:
        tmpdir = Path(tmpdir)

        with zipfile.ZipFile(bundle_path, "r") as zf:
            zf.extractall(tmpdir)

        env_path = tmpdir / "env.json"
        metadata_path = tmpdir / "metadata.json"
        model_path = tmpdir / "model.zip"

        with env_path.open("r") as f:
            env_cfg = json.load(f)

        if metadata_path.exists():
            with metadata_path.open("r") as f:
                metadata = json.load(f)
        else:
            metadata = {"algo": "PPO"}

        if args.mode == "gui":
            env_cfg["has_renderer"] = True
            env_cfg["has_offscreen_renderer"] = False
            env_cfg["use_camera_obs"] = False

        env = suite.make(**env_cfg)

        algo = metadata.get("algo", "PPO")
        model_cls = MODEL_CLASSES[algo]
        model = model_cls.load(str(model_path))

        obs = env.reset()

        try:
            while True:
                action, _ = model.predict(obs, deterministic=args.deterministic)
                obs, reward, done, info = env.step(action)

                if args.mode == "gui":
                    env.render()
                    time.sleep(1 / args.fps)

                if done:
                    obs = env.reset()
        finally:
            env.close()


if __name__ == "__main__":
    main()