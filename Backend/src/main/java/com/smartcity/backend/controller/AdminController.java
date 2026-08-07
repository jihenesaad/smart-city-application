package com.smartcity.backend.controller;

import com.smartcity.backend.dto.User.AdminAuthRequest;
import com.smartcity.backend.dto.User.AuthResponse;
import com.smartcity.backend.service.User.AuthService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Profile("dev")
@RequestMapping("/api/auth/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> registerAdmin(
            @Valid @RequestBody AdminAuthRequest request,
            HttpServletResponse response
    ) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(authService.registerAdmin(request, response));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> loginAdmin(
            @Valid @RequestBody AdminAuthRequest request,
            HttpServletResponse response
    ) {
        return ResponseEntity.ok(authService.loginAdmin(request, response));
    }
}
