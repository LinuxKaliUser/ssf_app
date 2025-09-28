package com.ssf.backend.account;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.ssf.backend.config.JwtUtil;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/accounts")
@Validated
public class AccountController {
    private final AccountService accountService;

    @Autowired
    public AccountController(AccountService accountService) {
        this.accountService = accountService;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody Map<String, String> req) {
        try {
            Account acc = accountService.register(
                req.getOrDefault("email", ""),
                req.getOrDefault("username", ""),
                req.getOrDefault("password", "")
            );
            return ResponseEntity.ok(acc);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> req) {
        var username = req.getOrDefault("username", "");
        var password = req.getOrDefault("password", "");
        return accountService.login(username, password)
            .map(user -> ResponseEntity.ok(Map.of(
                "token", JwtUtil.generateToken(username),
                "user", user
            )))
            .orElseGet(() -> ResponseEntity.status(401).body(Map.of("error", "Falscher Benutzername oder Passwort")));
    }

    @GetMapping
    public List<Account> all() {
        return accountService.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> byId(@PathVariable Long id) {
        return accountService.findById(id)
            .map(ResponseEntity::ok)
            .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
