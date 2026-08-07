package com.smartcity.backend.repository;

import com.smartcity.backend.entitiy.RefreshToken;
import com.smartcity.backend.entitiy.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {

    Optional<RefreshToken> findByToken(String token);

    void deleteAllByUser(User user);
}
