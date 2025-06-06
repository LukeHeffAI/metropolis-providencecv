# SPDX-FileCopyrightText: Copyright (c) 2024 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/use-case_config.yaml"
  exit 1
fi

DEFAULT_CONFIG_PATH=$1

export BACKEND_PORT=8000
export FRONTEND_PORT=9000
export NVIDIA_API_KEY=<NVIDIA_API-KEY>
export NGC_API_KEY=<YOUR-NGC-API-KEY>
export MODEL_PATH="ngc:nvidia/tao/vita:2.0.1"
export NGC_MODEL_CACHE=</SOME/DIR/ON/HOST>

docker run --rm -it --ipc=host --ulimit memlock=-1 \
--ulimit stack=67108864 --tmpfs /tmp:exec --name via-server \
--gpus '"device=all"' \
-p $FRONTEND_PORT:$FRONTEND_PORT \
-p $BACKEND_PORT:$BACKEND_PORT \
-e VIA_DEV_API=1 \
-e BACKEND_PORT=$BACKEND_PORT \
-e FRONTEND_PORT=$FRONTEND_PORT \
-e NVIDIA_API_KEY=$NVIDIA_API_KEY \
-e NGC_API_KEY=$NGC_API_KEY \
-e VLM_MODEL_TO_USE=vita-2.0 \
-v $NGC_MODEL_CACHE:/root/.via/ngc_model_cache \
-e MODEL_PATH=$MODEL_PATH \
-v via-hf-cache:/tmp/huggingface \
-v $DEFAULT_CONFIG_PATH:/opt/nvidia/via/default_config.yaml \
nvcr.io/metropolis/via-dp/via-engine:2.0-dp