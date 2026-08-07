package com.smartcity.backend.dto.User;

import com.smartcity.backend.entitiy.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthResponse {
    private String email;
    private String firstName;
    private String lastName;
    private Role role;
}
