package com.UPOX.upox_back_end.service;

import com.UPOX.upox_back_end.dto.request.UserCreationRequest;
import com.UPOX.upox_back_end.dto.request.UserUpdateRequest;
import com.UPOX.upox_back_end.dto.response.UserResponse;
import com.UPOX.upox_back_end.entity.User;
//import com.UPOX.upox_back_end.mapper.UserMapper;
import com.UPOX.upox_back_end.enums.Role;
import com.UPOX.upox_back_end.exception.ErrorCode;
import com.UPOX.upox_back_end.model.Mapper;
import com.UPOX.upox_back_end.repository.UserRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class UserService{ //Xử lý business logic

    UserRepository userRepository;


    private Mapper userMapper = new Mapper();

    public UserResponse createRequest(UserCreationRequest objRequest){


        if(userRepository.existsByUsername(objRequest.getUsername())){
            throw new RuntimeException();
        }

        //Dùng phổ biến
        //Chỉ cần 1 vài attribute nhất định, không cần tất cả


//        User newUser = new User();
//        newUser.setUsername(objRequest.getUsername());
//        newUser.setPassword(objRequest.getPassword());
//        newUser.setFirstname(objRequest.getFirstname());
//        newUser.setLastname(objRequest.getLastname());
//        newUser.setDob(objRequest.getDob());

        User newUser = userMapper.toUser(objRequest);
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
        //Độ mạnh càng lớn thì mật khẩu sẽ càng khó giải mã
        //Mạnh quá thì ảnh hưởng performance
        newUser.setPassword(passwordEncoder.encode(objRequest.getPassword()));

        //Set roles cho user --> khi mới tạo thì người dùng chỉ có một role duy nhất là USER thoi
        HashSet<String> roles = new HashSet<>(); //Tạo thành một Set
        roles.add(Role.USER.name());
        newUser.setRoles(roles);

        userRepository.save(newUser); //CREATE user mới

        return userMapper.toUserResponse(newUser);
    }


    @PreAuthorize("hasAuthority('SCOPE_ADMIN')") //PreAuthorize: Spring sẽ tạo ra một Proxy trước lúc gọi hàm để check quyền users
    public List<User> getUsers(){
        log.info("Accessed method getUsers()");
        return userRepository.findAll();
    }

    @PostAuthorize("returnObject.username == authentication.name") //PostAuthorize: Sẽ được gọi sau khi method hoàn tất hàm
    public UserResponse getUserByID(String Id){
        log.info("Accessed method getUserByID()");
        return  userMapper.toUserResponse(
                userRepository.findById(Id).orElseThrow(() -> new RuntimeException("User not found")));
    }

    public UserResponse updateRequest(String Id, UserUpdateRequest objUpdateRequest){
        User needUpdateUser = userRepository.findById(Id).orElseThrow(()
                -> new RuntimeException("User not found"));

        String oldPass = needUpdateUser.getPassword();
        String newPass = !Objects.isNull(objUpdateRequest.getPassword())? objUpdateRequest.getPassword() : oldPass;

        userMapper.updateUser(needUpdateUser,objUpdateRequest);

        if(!oldPass.equals(newPass)){
            PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
            needUpdateUser.setPassword(passwordEncoder.encode(newPass));
        }

        userRepository.save(needUpdateUser); //UPDATE user mới


        return userMapper.toUserResponse(needUpdateUser);
    }

    public void deleteRequest(String Id){
        userRepository.deleteById(Id);
    }

    public boolean isEmailExisted(String email){
        return userRepository.existsByEmail(email);
    }

    public UserResponse getMyInfo(){
        //Khi user được xác thực thành công thì thông tin user sẽ được lưu ở SecurityContextHolder
        var context = SecurityContextHolder.getContext();
        String userName = context.getAuthentication().getName();
        log.info(userName);
//        Object principalObject = context.getAuthentication().getPrincipal();
//        log.info(principalObject.toString());

        User user = userRepository.findByUsername(userName)
                .orElseThrow(() -> new RuntimeException(ErrorCode.USER_NOT_EXISTED.getMessage()));

        return userMapper.toUserResponse(user);
    }
}
