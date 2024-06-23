package com.capapp.backend.exceptions;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;

import java.time.LocalDateTime;

public record ApiError(

        String path,

        String message,

        int statusCode,

        @JsonSerialize(using = LocalDateTimeSerializer.class)
        @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
        LocalDateTime timeStamp
) {

}

