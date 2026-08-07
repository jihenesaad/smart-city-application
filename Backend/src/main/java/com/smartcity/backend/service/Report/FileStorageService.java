package com.smartcity.backend.service.Report;

import com.smartcity.backend.exception.AiProcessingException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.UUID;

@Service
public class FileStorageService {

    @Value("${app.upload-dir:uploads}")
    private String uploadDir;

    public String store(MultipartFile file) {
        try {
            Path dirPath = Path.of(uploadDir);
            Files.createDirectories(dirPath);

            String extension = getExtension(file.getOriginalFilename());
            String filename = UUID.randomUUID() + extension;
            Path targetPath = dirPath.resolve(filename);

            Files.copy(file.getInputStream(), targetPath);

            return "/uploads/" + filename;
        } catch (IOException e) {
            throw new AiProcessingException("Échec du stockage de l'image", e);
        }
    }

    private String getExtension(String originalFilename) {
        if (originalFilename == null || !originalFilename.contains(".")) return "";
        return originalFilename.substring(originalFilename.lastIndexOf('.'));
    }
}