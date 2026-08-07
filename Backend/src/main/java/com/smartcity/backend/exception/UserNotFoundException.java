package com.smartcity.backend.exception;

import org.springframework.http.HttpStatus;

public class UserNotFoundException extends AuthException {

    public UserNotFoundException(String identifier) {
        super("User not found : " + identifier, HttpStatus.NOT_FOUND);
    }
}
