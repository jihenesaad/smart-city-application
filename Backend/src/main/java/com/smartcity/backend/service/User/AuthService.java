package com.smartcity.backend.service.User;

import com.smartcity.backend.dto.User.AdminAuthRequest;
import com.smartcity.backend.dto.User.AuthResponse;
import com.smartcity.backend.dto.User.LoginRequest;
import com.smartcity.backend.dto.User.RegisterRequest;
import com.smartcity.backend.entitiy.RefreshToken;
import com.smartcity.backend.entitiy.Role;
import com.smartcity.backend.entitiy.User;
import com.smartcity.backend.exception.InvalidCredentialsException;
import com.smartcity.backend.exception.InvalidRefreshTokenException;
import com.smartcity.backend.exception.UserAlreadyExistsException;
import com.smartcity.backend.exception.UserNotFoundException;
import com.smartcity.backend.repository.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final RefreshTokenService refreshTokenService;
    private final CookieService cookieService;


    @Transactional
    public AuthResponse register(RegisterRequest request, HttpServletResponse response) {

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new UserAlreadyExistsException(request.getEmail());
        }

        User user = User.builder()
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.USER)
                .build();

        userRepository.save(user);

        setCookies(user, response);

        return buildAuthResponse(user);
    }


    public AuthResponse login(LoginRequest request, HttpServletResponse response) {

        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getEmail(),
                            request.getPassword()
                    )
            );
        } catch (BadCredentialsException e) {
            throw new InvalidCredentialsException();
        }

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UserNotFoundException(request.getEmail()));

        setCookies(user, response);     // ← délègue au CookieService

        return buildAuthResponse(user);
    }


    public AuthResponse refreshToken(HttpServletRequest request, HttpServletResponse response) {


        String refreshToken = cookieService.getRefreshTokenFromCookies(request);

        if (refreshToken == null) {
            throw new InvalidRefreshTokenException();
        }


        RefreshToken storedToken = refreshTokenService.findByToken(refreshToken)
                .orElseThrow(InvalidRefreshTokenException::new);

        refreshTokenService.verifyExpiration(storedToken);


        User user = storedToken.getUser();
        String newAccessToken = jwtService.generateToken(user);


        response.addHeader(
                HttpHeaders.SET_COOKIE,
                cookieService.generateAccessTokenCookie(newAccessToken).toString()
        );

        return buildAuthResponse(user);
    }


    public void logout(HttpServletResponse response){

        ResponseCookie cookie =
                ResponseCookie.from("access_token", "")
                        .httpOnly(true)
                        .secure(false)
                        .path("/")
                        .maxAge(0)
                        .build();

        response.addHeader(
                HttpHeaders.SET_COOKIE,
                cookie.toString()
        );
    }


    private void setCookies(User user, HttpServletResponse response) {

        String accessToken = jwtService.generateToken(user);
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(user);

        response.addHeader(
                HttpHeaders.SET_COOKIE,
                cookieService.generateAccessTokenCookie(accessToken).toString()
        );
        response.addHeader(
                HttpHeaders.SET_COOKIE,
                cookieService.generateRefreshTokenCookie(refreshToken.getToken()).toString()
        );
    }


    private AuthResponse buildAuthResponse(User user) {
        return AuthResponse.builder()
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .role(user.getRole())
                .build();
    }


    @Transactional
    public AuthResponse registerAdmin(
            AdminAuthRequest request,
            HttpServletResponse response
    ) {

        if (userRepository.existsByEmail(request.email())) {
            throw new UserAlreadyExistsException(request.email());
        }

        User admin = User.builder()
                .firstName("Admin")
                .lastName("Admin")
                .email(request.email())
                .password(passwordEncoder.encode(request.password()))
                .role(Role.ADMIN)
                .build();

        userRepository.save(admin);

        setCookies(admin, response);

        return buildAuthResponse(admin);
    }


    public AuthResponse loginAdmin(AdminAuthRequest request, HttpServletResponse response) {

        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.email(),
                            request.password()
                    )
            );
        } catch (BadCredentialsException e) {
            throw new InvalidCredentialsException();
        }

        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new UserNotFoundException(request.email()));

        if (user.getRole() != Role.ADMIN) {
            throw new AccessDeniedException("Ce compte n'a pas les droits administrateur");
        }

        setCookies(user, response);

        return buildAuthResponse(user);
    }
}