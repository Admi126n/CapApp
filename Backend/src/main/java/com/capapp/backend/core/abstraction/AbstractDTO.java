package com.capapp.backend.core.abstraction;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@SuperBuilder
@AllArgsConstructor
@NoArgsConstructor
public abstract class AbstractDTO {

    private Long ID;

    private LocalDateTime createDate;

    private Long createdBy;

    private LocalDateTime updateDate;

    private Long updatedBy;

    private Long version;
}
