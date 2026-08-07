package com.smartcity.backend.service.Report;

import com.fasterxml.jackson.databind.JsonNode;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.smartcity.backend.configuration.AiProperties;
import com.smartcity.backend.dto.Report.ImageAnalysisResult;
import com.smartcity.backend.exception.AiProcessingException;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.Base64;
import java.util.List;
import java.util.Map;


@Component
public class VisionAiClient {

    private static final String SYSTEM_PROMPT = """
        You are a visual image analysis assistant.

        Your task is to describe ONLY what is visible in the image.

        Do not write a report.
        Do not mention "the report", "the user", "the issue", or "the request".
        Do not provide recommendations or maintenance suggestions.

        Describe:
        - visible objects
        - visible damages or defects
        - visible conditions
        - potential hazards only if they are directly visible

        Rules:
        - Be factual and objective.
        - Do not infer causes.
        - Do not guess hidden information.
        - Do not suggest solutions.
        - Do not classify into categories.
        - Do not mention ROAD, WASTE, LIGHT, WATER.
        - Use a neutral description style.
        - Keep the description concise (1-2 sentences).

        Example of correct style:
        "A rusty faucet connected to an old pipe is visible. A water drop is falling from the faucet."

        Example of incorrect style:
        "The report indicates a leaking faucet that needs maintenance."
        """;


    private final RestClient openRouterRestClient;
    private final AiProperties aiProperties;
    private final ObjectMapper objectMapper;


    public VisionAiClient(
            RestClient openRouterRestClient,
            AiProperties aiProperties,
            ObjectMapper objectMapper
    ) {
        this.openRouterRestClient = openRouterRestClient;
        this.aiProperties = aiProperties;
        this.objectMapper = objectMapper;
    }



    public ImageAnalysisResult analyze(byte[] imageBytes, String mimeType) {

        System.out.println(
                "Vision model = " + aiProperties.openrouter().visionModel()
        );

        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
        String dataUri = "data:" + mimeType + ";base64," + base64Image;

        Map<String, Object> requestBody = Map.of(
                "model", aiProperties.openrouter().visionModel(),
                "messages", List.of(
                        Map.of(
                                "role", "system",
                                "content", SYSTEM_PROMPT
                        ),
                        Map.of(
                                "role", "user",
                                "content", List.of(
                                        Map.of(
                                                "type", "text",
                                                "text", "Describe the issue visible in this image."
                                        ),
                                        Map.of(
                                                "type", "image_url",
                                                "image_url", Map.of(
                                                        "url", dataUri
                                                )
                                        )
                                )
                        )
                ),
                "temperature", 0.2,
                "max_tokens", 200
        );

        try {
            String rawResponse = openRouterRestClient.post()
                    .uri("/chat/completions")
                    .body(requestBody)
                    .retrieve()
                    .body(String.class);

            String description = extractContent(rawResponse);

            return new ImageAnalysisResult(description.trim());

        } catch (Exception e) {
            throw new AiProcessingException(
                    "Failed to analyze image using Nemotron 3 Nano Omni: "
                            + e.getMessage(),
                    e
            );
        }
    }





    private String extractContent(
            String rawJson
    ) {

        try {


            JsonNode root =
                    objectMapper.readTree(rawJson);



            JsonNode choices =
                    root.path("choices");



            if (!choices.isArray()
                    || choices.isEmpty()) {


                throw new AiProcessingException(
                        "No response choices returned by Nemotron"
                );
            }



            String content =
                    choices.get(0)
                            .path("message")
                            .path("content")
                            .asText();



            if (content == null
                    || content.isBlank()) {


                throw new AiProcessingException(
                        "Empty image analysis returned by Nemotron"
                );
            }


            return content;



        } catch (Exception e) {


            throw new AiProcessingException(
                    "Invalid response received from Nemotron: "
                            + rawJson,
                    e
            );
        }
    }
}
