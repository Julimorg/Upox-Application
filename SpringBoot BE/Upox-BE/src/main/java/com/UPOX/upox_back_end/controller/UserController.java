package com.UPOX.upox_back_end.controller;

import com.UPOX.upox_back_end.dto.response.ApiResponse;
import com.UPOX.upox_back_end.dto.request.UserCreationRequest;
import com.UPOX.upox_back_end.dto.request.UserUpdateRequest;
import com.UPOX.upox_back_end.dto.response.UserResponse;
import com.UPOX.upox_back_end.entity.User;
import com.UPOX.upox_back_end.service.TrackedUserProductService;
import com.UPOX.upox_back_end.service.UserService;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = "/users")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private TrackedUserProductService trackedUserProductService;

    //Đăng ký
    @PostMapping
    ApiResponse<UserResponse> createUser(@RequestBody @Valid UserCreationRequest objRequest){
        //@Valid khai báo cho framework biết là phải validate obj này theo rule đã set sẵn

        //Bọc kết quả trả về vào trong API response theo 1 chuẩn cụ thể
        ApiResponse<UserResponse> apiResponse = new ApiResponse<>();
        var res = userService.createRequest(objRequest);
        trackedUserProductService.createExpense(res.getUsername());
        apiResponse.setResult(res);
        return apiResponse;
    }

    @GetMapping
    ApiResponse<List<User>> getUser(){
        ApiResponse<List<User>> apiResponse = new ApiResponse<>();
        apiResponse.setResult(userService.getUsers());
        return apiResponse;
    }

    @GetMapping("/{userId}")
    ApiResponse<UserResponse> getUser(@PathVariable("userId") String userId){
        ApiResponse<UserResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(userService.getUserByID(userId));
        return apiResponse;
    }

    @GetMapping("/myInfo")
    ApiResponse<UserResponse> getSelfInfo(){
        ApiResponse<UserResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(userService.getMyInfo());
        return apiResponse;
    }

    @PutMapping("{userId}") //update information
    ApiResponse<UserResponse> updateUser(@PathVariable("userId") String userId, @RequestBody @Valid UserUpdateRequest objRequest){
        ApiResponse<UserResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(userService.updateRequest(userId,objRequest));
        return apiResponse;
    }

    //Cho phép access mà không cần gửi token
    @PutMapping("/forget-password/{userId}") //update information
    ApiResponse<UserResponse> updatePassword(@PathVariable("userId") String userId, @RequestBody @Valid UserUpdateRequest objRequest){
        ApiResponse<UserResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(userService.updateRequest(userId,objRequest));
        return apiResponse;
    }

    @DeleteMapping("{userId}")
    String deleteUser(@PathVariable("userId") String userId){
        userService.deleteRequest(userId);
        return "Delete Successfully";
    }


}
