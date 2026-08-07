package com.smartcity.backend.exception;

import org.springframework.http.HttpStatus;

public class InvalidCredentialsException extends AuthException {

    public InvalidCredentialsException() {
        super("Incorrect Email or password", HttpStatus.UNAUTHORIZED);
    }
}
