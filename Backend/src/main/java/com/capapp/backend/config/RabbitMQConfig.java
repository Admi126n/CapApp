package com.capapp.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@PropertySource("classpath:rabbit.properties")
public class RabbitMQConfig {
}
