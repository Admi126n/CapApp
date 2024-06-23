package com.capapp.backend.config.security;

import com.capapp.backend.exceptions.ApiError;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.LocalDateTime;

@Component
@RequiredArgsConstructor
public class JwtAuthFilter extends OncePerRequestFilter {


    private final JwtService jwtService;

    private final UserDetailsService userDetailsService;

    private final ObjectMapper mapper;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterchain
    ) throws ServletException, IOException {

        final String authHeader = request.getHeader("Authorization");
        final String userEmail;
        final String jwtToken;

        try {
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                filterchain.doFilter(request, response);
                return;
            }
            jwtToken = authHeader.substring(7);
            userEmail = jwtService.extractUsername(jwtToken);

            if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = this.userDetailsService.loadUserByUsername(userEmail);
                if (jwtService.isTokenValid(jwtToken, userDetails)) {
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails,
                            null,
                            userDetails.getAuthorities()
                    );
                    authToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request)
                    );
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                }
            }
            filterchain.doFilter(request, response);
        } catch (RuntimeException e) {

            ApiError apiError = new ApiError(
                    request.getRequestURI(),
                    e.getMessage(),
                    HttpStatus.FORBIDDEN.value(),
                    LocalDateTime.now()
            );

            response.setStatus(apiError.statusCode());
            response.setContentType("application/json");
            response.getWriter().write(this.mapper.writeValueAsString(apiError));
        }
    }
}
