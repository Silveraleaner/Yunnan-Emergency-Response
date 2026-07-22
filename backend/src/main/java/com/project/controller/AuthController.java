package com.project.controller;

import com.project.common.Result;
import com.project.dto.auth.LoginRequest;
import com.project.dto.auth.LoginResponse;
import com.project.dto.auth.RegisterRequest;
import com.project.entity.mysql.User;
import com.project.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<Result<LoginResponse>> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = authService.login(request);
        return ResponseEntity.ok(Result.success("登录成功", response));
    }

    @PostMapping("/register")
    public ResponseEntity<Result<User>> register(@Valid @RequestBody RegisterRequest request) {
        User user = authService.register(request);
        return ResponseEntity.ok(Result.success("注册成功", user));
    }
}