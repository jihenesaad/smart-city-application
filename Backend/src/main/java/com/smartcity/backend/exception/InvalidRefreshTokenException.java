package com.smartcity.backend.exception;

import org.springframework.http.HttpStatus;

public class InvalidRefreshTokenException extends AuthException {

    public InvalidRefreshTokenException() {
        super("Refresh token invalid or not found.", HttpStatus.UNAUTHORIZED);
    }
}