package com.smartcity.backend.configuration;

import org.springframework.boot.context.properties.ConfigurationProperties;


@ConfigurationProperties(prefix = "ai")
public record AiProperties(
        OpenRouter openrouter
) {

    public record OpenRouter(
            String baseUrl,
            String apiKey,
            String classificationModel,
            String visionModel
    ) {}
}
