package com.capapp.backend.core.repositories;

import com.capapp.backend.core.abstraction.AbstractRepository;
import com.capapp.backend.core.entities.UserEntity;

import java.util.Optional;


public interface UserRepository extends AbstractRepository<UserEntity> {

    boolean existsByEmail(String email);

    Optional<UserEntity> findByEmail(String email);


}
