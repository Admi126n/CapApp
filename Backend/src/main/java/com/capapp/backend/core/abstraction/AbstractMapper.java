package com.capapp.backend.core.abstraction;



import org.mapstruct.Mapping;

import java.util.List;

public interface AbstractMapper <DTO extends AbstractDTO, Entity extends AbstractEntity>{

    @Mapping(target = "createDate", defaultExpression = "java(java.time.LocalDateTime.now())")
    Entity mapToEntity(DTO dto);

    DTO mapToDTO(Entity entity);

    default List<Entity> mapToEntityList(List<DTO> dtos){
        return dtos.stream()
                .map(this::mapToEntity)
                .toList();
    }

    default List<DTO> mapToDTOList(List<Entity> entities){
        return entities.stream()
                .map(this::mapToDTO)
                .toList();
    }

}
