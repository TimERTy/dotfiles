import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const BASE_URL_ENV = "LITELLM_BASE_URL";
const API_KEY_ENV = "LITELLM_API_KEY";

interface LiteLLMModel {
  id: string;
  object?: string;
  owned_by?: string;
}

interface LiteLLMModelsResponse {
  data?: LiteLLMModel[];
}

export default async function (pi: ExtensionAPI) {
  const rawBaseUrl = process.env[BASE_URL_ENV];
  if (!rawBaseUrl) {
    console.error(`[litellm] ${BASE_URL_ENV} is not set, skipping provider registration`);
    return;
  }

  const baseUrl = rawBaseUrl.replace(/\/+$/, "");
  const apiKey = process.env[API_KEY_ENV];

  let payload: LiteLLMModelsResponse;
  try {
    const response = await fetch(`${baseUrl}/v1/models`, {
      headers: apiKey ? { Authorization: `Bearer ${apiKey}` } : {},
    });
    if (!response.ok) {
      console.error(`[litellm] GET /v1/models failed: ${response.status} ${response.statusText}`);
      return;
    }
    payload = (await response.json()) as LiteLLMModelsResponse;
  } catch (error) {
    console.error(`[litellm] Could not reach ${baseUrl}: ${error instanceof Error ? error.message : error}`);
    return;
  }

  const models = payload.data ?? [];
  if (models.length === 0) {
    console.error("[litellm] Proxy returned no models");
    return;
  }

  pi.registerProvider("litellm", {
    name: "LiteLLM",
    baseUrl: `${baseUrl}/v1`,
    apiKey: `$${API_KEY_ENV}`,
    api: "openai-completions",
    models: models.map((model) => ({
      id: model.id,
      name: model.id,
      reasoning: false,
      input: ["text"],
      cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
      contextWindow: 128000,
      maxTokens: 8192,
    })),
  });
}
