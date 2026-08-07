package com.smartcity.backend.service.Report;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.smartcity.backend.configuration.AiProperties;
import com.smartcity.backend.dto.Report.ClassificationResult;
import com.smartcity.backend.exception.AiProcessingException;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.Map;


@Component
public class ClassificationAiClient {

    private static final String SYSTEM_PROMPT = """
            You are a smart city report classification assistant.

        Analyze the citizen report and generate:
        - a short title
        - a category
        - an improved description

        Allowed categories:
        - ROAD
        - WASTE
        - LIGHT
        - WATER

        If the title or description is missing, generate them from the image analysis.

        Return ONLY JSON:

        {
          "title": "Short issue title",
          "category": "ROAD",
          "description": "Detailed issue description"
        }

        Rules:
        - category must be exactly ROAD, WASTE, LIGHT or WATER.
        - No markdown.
        - No explanations.
        """;


    private final RestClient openRouterRestClient;
    private final AiProperties aiProperties;
    private final ObjectMapper objectMapper;


    public ClassificationAiClient(
            RestClient openRouterRestClient,
            AiProperties aiProperties,
            ObjectMapper objectMapper
    ) {
        this.openRouterRestClient = openRouterRestClient;
        this.aiProperties = aiProperties;
        this.objectMapper = objectMapper;
    }


    public ClassificationResult classify(
            String title,
            String description,
            String imageAnalysis
    ) {

        String userPrompt = buildUserPrompt(
                title,
                description,
                imageAnalysis
        );


        Map<String, Object> requestBody = Map.of(
                "model",
                aiProperties.openrouter().classificationModel(),

                "messages",
                List.of(
                        Map.of(
                                "role",
                                "system",
                                "content",
                                SYSTEM_PROMPT
                        ),
                        Map.of(
                                "role",
                                "user",
                                "content",
                                userPrompt
                        )
                ),

                "temperature",
                0,

                "max_tokens",
                200
        );


        try {

            String rawResponse =
                    openRouterRestClient.post()
                            .uri("/chat/completions")
                            .body(requestBody)
                            .retrieve()
                            .body(String.class);


            String jsonContent = extractContent(rawResponse);


            ClassificationResult result = objectMapper.readValue(
                    jsonContent,
                    ClassificationResult.class
            );

            if (result == null || result.category() == null) {
                throw new AiProcessingException(
                        "AI returned an invalid or empty classification result: " + jsonContent
                );
            }

            return result;

        } catch (Exception e) {

            e.printStackTrace();

            throw new AiProcessingException(
                    "Failed to classify report using GPT-OSS 20B: "
                            + e.getMessage(),
                    e
            );
        }
    }


    private String buildUserPrompt(
            String title,
            String description,
            String imageAnalysis
    ) {

        StringBuilder prompt = new StringBuilder();

        prompt.append("Report title:\n")
                .append(title)
                .append("\n\n");


        prompt.append("Report description:\n")
                .append(
                        description == null || description.isBlank()
                                ? "No description provided"
                                : description
                )
                .append("\n\n");


        if (imageAnalysis != null && !imageAnalysis.isBlank()) {

            prompt.append("Image analysis:\n")
                    .append(imageAnalysis)
                    .append("\n\n");
        }


        prompt.append(
                "Classify this report and return only the JSON object."
        );


        return prompt.toString();
    }



    private String extractContent(String rawJson) {

        try {

            JsonNode root =
                    objectMapper.readTree(rawJson);


            JsonNode choices =
                    root.path("choices");


            if (choices.isEmpty()) {
                throw new AiProcessingException(
                        "No response choices returned by OpenRouter"
                );
            }


            String content =
                    choices.get(0)
                            .path("message")
                            .path("content")
                            .asText();


            if (content == null || content.isBlank()) {
                throw new AiProcessingException(
                        "Empty response content from GPT-OSS 20B"
                );
            }


            return cleanJson(content);


        } catch (Exception e) {

            throw new AiProcessingException(
                    "Invalid response format from GPT-OSS 20B: "
                            + rawJson,
                    e
            );
        }
    }



    private String cleanJson(String content) {

        return content
                .replace("```json", "")
                .replace("```", "")
                .trim();
    }
}