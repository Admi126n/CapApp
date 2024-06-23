package com.capapp.backend.core.abstraction;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.LocalDateTime;

@Data
@MappedSuperclass
@SuperBuilder
@NoArgsConstructor
public abstract class AbstractEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long ID;

    @CreatedDate
    @Column(nullable = false, updatable = false)
    @Builder.Default
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime createDate = LocalDateTime.now();

    @CreatedBy
    @Column(updatable = false)
    private Long createdby;

    @LastModifiedDate
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime updateDate;

    @Column
    private Long updatedBy;

    @Version
    private Long version;
}
