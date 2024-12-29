package com.UPOX.upox_back_end;

import com.UPOX.upox_back_end.entity.TrackedUserProduct;
import jakarta.persistence.Id;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;

import java.lang.reflect.Field;

@SpringBootApplication
@Slf4j
@EnableTransactionManagement
@EnableScheduling
public class UpoxBackEndApplication {

	public static void main(String[] args) {
		SpringApplication.run(UpoxBackEndApplication.class, args);
//		String categories = "name-name-name-name-name";
//		String[] stringsPart = categories.split("-",5);
//		for (var str: stringsPart) {
//			log.info(str);
//		}

//		for (Field field : TrackedUserProduct.class.getDeclaredFields()) {
//			if (field.isAnnotationPresent(Id.class)) {
//				log.info(field.getName() + " is the primary key.");
//			}
//		}
	}

}
