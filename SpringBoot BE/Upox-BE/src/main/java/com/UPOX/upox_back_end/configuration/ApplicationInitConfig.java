package com.UPOX.upox_back_end.configuration;

import com.UPOX.upox_back_end.entity.Status;
import com.UPOX.upox_back_end.entity.User;
import com.UPOX.upox_back_end.enums.Role;
import com.UPOX.upox_back_end.enums.StatusE;
import com.UPOX.upox_back_end.repository.StatusRepository;
import com.UPOX.upox_back_end.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.HashSet;

@Configuration
@RequiredArgsConstructor
@Slf4j
public class ApplicationInitConfig {

    @Autowired
    private final PasswordEncoder passwordEncoder;

    @Bean
    ApplicationRunner applicationRunner(UserRepository userRepository, StatusRepository statusRepository){
        //Sẽ được chạy mỗi khi Application Start, add role ADMIN vào User nào đó
        return args -> {
            //Kiểm tra User Admin có tồn tại hay chưa
            //Nếu chưa tồn tại --> Đây là lần đầu Application được chạy --> thêm ADMIN
            if(userRepository.findByUsername("admin").isEmpty()){
                HashSet<String> roles = new HashSet<>(); //Tạo thành một Set
                roles.add(Role.ADMIN.name());



                User user = User.builder() //Tạo user admin
                        .username("admin") //Có thể giấu thông tin trong application.properties
                        .password(passwordEncoder.encode("admin"))
                        .roles(roles)
                        .build();

                userRepository.save(user);
                log.warn("\"admin\" user has been created with default password: admin" +
                        ",please change it!");
            }

        };
    }

    //Tạo các hàm chạy đình kỳ để clean DB
}
