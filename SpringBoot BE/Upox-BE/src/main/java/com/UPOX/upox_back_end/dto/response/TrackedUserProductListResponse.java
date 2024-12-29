package com.UPOX.upox_back_end.dto.response;


import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.ArrayList;
import java.util.List;

@Data //Cung cấp các method getter/setter, toString, equalHashCode, requiredArgsConstructor
@NoArgsConstructor
@AllArgsConstructor
@Builder //Tạo ra 1 builder class cho một DTO
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrackedUserProductListResponse {
    List<TrackedUserProductResponse> responseList;
    public void addResponse(TrackedUserProductResponse response){
        if(responseList == null){
            responseList = new ArrayList<>();
        }
        responseList.add(response);
    }
}
