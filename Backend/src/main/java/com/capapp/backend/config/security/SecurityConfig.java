package com.capapp.backend.config.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.annotation.web.configurers.HeadersConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
@EnableMethodSecurity(
        jsr250Enabled = true,
        securedEnabled = true
)
public class SecurityConfig {

    private final AuthenticationProvider authProvider;

    private final JwtAuthFilter jwtAuthFilter;

    @Bean
    @Profile("dev")
    protected SecurityFilterChain devFilter(HttpSecurity http) throws Exception {

        enableH2Access(http)
            .authorizeHttpRequests(
                    authorizationManagerRequestMatcherRegistry ->
                            authorizationManagerRequestMatcherRegistry.anyRequest().permitAll()
            )
            .csrf(AbstractHttpConfigurer::disable)
            .httpBasic(AbstractHttpConfigurer::disable)
            .formLogin(AbstractHttpConfigurer::disable)
            .logout(AbstractHttpConfigurer::disable)
            .headers(httpSecurityHeadersConfigurer -> {
                httpSecurityHeadersConfigurer.frameOptions(HeadersConfigurer.FrameOptionsConfig::disable);
            });


        http.sessionManagement(
                httpSecuritySessionManagementConfigurer -> httpSecuritySessionManagementConfigurer.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
        );

        return http.build();
    }

    @Profile({"security", "prod"})
    @Bean
    public SecurityFilterChain securityTestSecurityFilterChain(HttpSecurity http) throws Exception {

        http.cors(AbstractHttpConfigurer::disable)
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests(authorizationManagerRequestMatcherRegistry -> authorizationManagerRequestMatcherRegistry
                    .requestMatchers("/swagger-ui/**").permitAll()
                    .requestMatchers("/v3/api-docs/**").permitAll()
                    .requestMatchers("/ws/**").permitAll())
            .authorizeHttpRequests(authorizationManagerRequestMatcherRegistry -> authorizationManagerRequestMatcherRegistry.anyRequest().authenticated())
            .formLogin(AbstractHttpConfigurer::disable)
            .sessionManagement(httpSecuritySessionManagementConfigurer -> httpSecuritySessionManagementConfigurer.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authenticationProvider(authProvider)
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    private HttpSecurity enableH2Access(HttpSecurity http) throws Exception {

        http.authorizeHttpRequests(
                authorizationManagerRequestMatcherRegistry -> authorizationManagerRequestMatcherRegistry
                        .requestMatchers(new AntPathRequestMatcher("/h2-console/**")).permitAll()
        );

        http.headers(
                httpSecurityHeadersConfigurer -> httpSecurityHeadersConfigurer
                        .frameOptions(HeadersConfigurer.FrameOptionsConfig::disable)
        );

        return http;
    }
}
