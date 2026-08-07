package com.smartcity.backend.exception;

import org.springframework.http.HttpStatus;

public class UserAlreadyExistsException extends AuthException {

    public UserAlreadyExistsException(String email) {
        super("An account with this email " + email + " already exists",
                HttpStatus.CONFLICT);
    }
}
