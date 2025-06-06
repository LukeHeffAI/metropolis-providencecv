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

import typing

from src.llm_service import LLMClient

IMPORT_EXCEPTION = None
IMPORT_ERROR_MESSAGE = (
    "LangchainLLMClientWrapper require the langchain package to be installed. "
    "Install it by running the following command:\n"
    "`conda env update --solver=libmamba -n morpheus "
    "--file morpheus/conda/environments/examples_cuda-121_arch-x86_64.yaml --prune`"
)

try:
    from langchain_core.callbacks import AsyncCallbackManagerForLLMRun
    from langchain_core.callbacks import CallbackManagerForLLMRun
    from langchain_core.language_models.llms import LLM
except ImportError as import_exc:
    IMPORT_EXCEPTION = import_exc


class LangchainLLMClientWrapper(LLM):

    client: LLMClient

    @property
    def _llm_type(self) -> str:
        """Return type of llm."""
        return "morpheus"

    def _call(
        self,
        prompt: str,
        stop: typing.Optional[list[str]] = None,
        run_manager: typing.Optional[CallbackManagerForLLMRun] = None,
        **kwargs: typing.Any,
    ) -> str:
        """Run the LLM on the given prompt and input."""

        return self.client.generate(prompt=prompt, stop=stop)

    async def _acall(
        self,
        prompt: str,
        stop: typing.Optional[list[str]] = None,
        run_manager: typing.Optional[AsyncCallbackManagerForLLMRun] = None,
        **kwargs: typing.Any,
    ) -> str:
        """Run the LLM on the given prompt and input."""
        return await self.client.generate_async(prompt=prompt, stop=stop)
