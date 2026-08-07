package com.smartcity.backend.exception;

import org.springframework.http.HttpStatus;

public class RefreshTokenExpiredException extends AuthException {

    public RefreshTokenExpiredException() {
        super("Refresh token expired. Please login again.",
                HttpStatus.UNAUTHORIZED);
    }
}
