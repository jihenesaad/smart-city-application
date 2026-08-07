package com.smartcity.backend.service.Report;

import com.smartcity.backend.dto.Report.ClassificationResult;
import com.smartcity.backend.dto.Report.ImageAnalysisResult;
import org.springframework.stereotype.Service;
/**
  Cas 1 (sans image)  : titre + description -> GPT-OSS 20B
  Cas 2 (avec image)  : image -> Nemotron 3 Nano Omni -> description factuelle
                       puis (titre + description + analyse image) -> GPT-OSS 20B
 **/
@Service
public class ReportAiOrchestrator {

    private final VisionAiClient visionAiClient;
    private final ClassificationAiClient classificationAiClient;

    public ReportAiOrchestrator(VisionAiClient visionAiClient, ClassificationAiClient classificationAiClient) {
        this.visionAiClient = visionAiClient;
        this.classificationAiClient = classificationAiClient;
    }

    public ClassificationResult process(String title, String description, byte[] imageBytes, String imageMimeType) {
        String imageAnalysis = null;

        if (imageBytes != null && imageBytes.length > 0) {
            ImageAnalysisResult visionResult = visionAiClient.analyze(imageBytes, imageMimeType);
            imageAnalysis = visionResult.description();
        }

        return classificationAiClient.classify(title, description, imageAnalysis);
    }
}