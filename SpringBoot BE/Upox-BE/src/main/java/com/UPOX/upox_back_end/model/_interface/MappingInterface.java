package com.UPOX.upox_back_end.model._interface;

import com.UPOX.upox_back_end.dto.request.TrackedUserProductRequest;
import com.UPOX.upox_back_end.dto.request.TrackedUserProductUpdateRequest;
import com.UPOX.upox_back_end.dto.request.UserCreationRequest;
import com.UPOX.upox_back_end.dto.request.UserUpdateRequest;
import com.UPOX.upox_back_end.dto.response.TrackedUserProductResponse;
import com.UPOX.upox_back_end.dto.response.UserResponse;
import com.UPOX.upox_back_end.entity.*;

public interface MappingInterface {

    User toUser(UserCreationRequest request);

    //Đôi khi sẽ phải map những properties không trùng nhau (source, target, ignore)
    UserResponse toUserResponse(User user);
    void updateUser(User user, UserUpdateRequest request);


    //Create Tracked User Product
    TrackedUserProduct toTrackedUserProduct(TrackedUserProductRequest request, Status status, Transaction transaction,
                                            Product product);

    //Update Tracked User Product
    void updateTrackedUserProduct(TrackedUserProduct trackedUserProduct, TrackedUserProductUpdateRequest updateRequest);

    //Create User Response
    TrackedUserProductResponse toTrackedUserProductResponse(TrackedUserProduct trackedUserProduct);


}
