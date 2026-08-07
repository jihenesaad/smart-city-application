package com.smartcity.backend.dto.Report;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.smartcity.backend.entitiy.Category;


/**
 * @JsonCreator + @JsonProperty permettent à Jackson de mapper directement
 * la réponse du LLM vers cet objet, sans étape de parsing manuel.
 */
public record ClassificationResult(
        String title,
        Category category,
        String description
) {

    @JsonCreator
    public ClassificationResult(
            @JsonProperty("title") String title,
            @JsonProperty("category") Category category,
            @JsonProperty("description") String description
    ) {
        this.title = title;
        this.category = category;
        this.description = description;
    }
}
