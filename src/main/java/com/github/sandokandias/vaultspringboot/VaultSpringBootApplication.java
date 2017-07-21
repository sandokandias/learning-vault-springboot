package com.github.sandokandias.vaultspringboot;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class VaultSpringBootApplication {

    public static void main(String[] args) {
        SpringApplication.run(VaultSpringBootApplication.class, args);
    }

    @RestController("/vault/token")
    public static class Controller {

        private final String vaultToken;

        public Controller(@Value("${zup.keyvault.auth.token}") String vaultToken) {
            this.vaultToken = vaultToken;
        }

        @GetMapping
        public String getVaultToken() {
            return vaultToken;
        }
    }
}
