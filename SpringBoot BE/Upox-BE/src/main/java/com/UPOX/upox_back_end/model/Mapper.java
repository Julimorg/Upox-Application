package com.UPOX.upox_back_end.model;

import com.UPOX.upox_back_end.dto.request.TrackedUserProductRequest;
import com.UPOX.upox_back_end.dto.request.TrackedUserProductUpdateRequest;
import com.UPOX.upox_back_end.dto.request.UserCreationRequest;
import com.UPOX.upox_back_end.dto.request.UserUpdateRequest;
import com.UPOX.upox_back_end.dto.response.TrackedUserProductResponse;
import com.UPOX.upox_back_end.dto.response.UserResponse;
import com.UPOX.upox_back_end.entity.*;
import com.UPOX.upox_back_end.model._interface.MappingInterface;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Objects;
import java.util.UUID;

public class Mapper implements MappingInterface {
    public Mapper() {
    }
    @Override
    public User toUser(UserCreationRequest request) {
        User newUser = new User();
        newUser.setUsername(request.getUsername());
        newUser.setPassword(request.getPassword());


        //Vừa thêm
        newUser.setActivated(false);
        newUser.setGoogleLogin(false);

        return newUser;
    }

    @Override
    public void updateUser(User needUpdateUser, UserUpdateRequest request) {

        needUpdateUser.setPassword(!Objects.isNull(request.getPassword())?request.getPassword():needUpdateUser.getPassword());
        needUpdateUser.setFirstName(!Objects.isNull(request.getFirstname())?request.getFirstname():needUpdateUser.getFirstName());
        needUpdateUser.setLastName(!Objects.isNull(request.getLastname())?request.getLastname():needUpdateUser.getLastName());
        needUpdateUser.setDob(!Objects.isNull(request.getDob())?request.getDob():needUpdateUser.getDob());
        needUpdateUser.setEmail(!Objects.isNull(request.getEmail())?request.getEmail():needUpdateUser.getEmail());
        needUpdateUser.setCity(!Objects.isNull(request.getCity())?request.getCity():needUpdateUser.getCity());
        needUpdateUser.setPhoneNum(!Objects.isNull(request.getPhoneNum())?request.getPhoneNum():needUpdateUser.getPhoneNum());
        needUpdateUser.setGender(request.getGender());

    }

    @Override
    public UserResponse toUserResponse(User user){
        UserResponse userResponse = new UserResponse();

        userResponse.setId(user.getId());
        userResponse.setUsername(user.getUsername());
//        userResponse.setPassword(user.getPassword());
        userResponse.setFirstname(user.getFirstName());
        userResponse.setLastname(user.getLastName());
        userResponse.setDob(user.getDob());
        userResponse.setEmail(user.getEmail());
        userResponse.setCity(user.getCity());
        userResponse.setPhoneNum(user.getPhoneNum());
        userResponse.setGender(user.getGender());
        userResponse.setRoles(user.getRoles());

        //Vừa thêm
        userResponse.setActivated(user.isActivated());
        userResponse.setGoogleLogin(user.isGoogleLogin());

        return  userResponse;
    }

    private LocalDateTime parseIntoLocalDate(String date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return LocalDateTime.parse(date, formatter);
    }

    private LocalDateTime calculateNextOpenExpiredDate(String strTimes, String strPeriod, LocalDateTime dateOpen){
        int times = Integer.parseInt(strTimes);
        LocalDateTime.now();
        return switch (strPeriod) {
            case ("year"), ("years") -> dateOpen.plusYears(times);
            case ("month"), ("months") -> dateOpen.plusMonths(times);
            case ("week"), ("weeks") -> dateOpen.plusWeeks(times);
            case ("day"), ("days") -> dateOpen.plusDays(times);
            case ("hour"), ("hours") -> dateOpen.plusHours(times);
            default -> LocalDateTime.now();
        };
    }

    public String generateProductInUse(double avgAmountUse, LocalDateTime dateOpen,
                                        double volumeLeft, LocalDateTime openExpiryDate){

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        String id = UUID.randomUUID().toString();
        String productInUseId = "\"id\": \"" + id + "\"";
        String statusId = "\"statusName\": \"" + "NORMAL" + "\"";
        String strAvgAmountUse = "\"avgAmountUse\": \"" + avgAmountUse + "\"";
        String strDateOpen = "\"dateOpen\": \"" + dateOpen.format(formatter) + "\"";

        LocalDateTime openDateStatusChange = LocalDateTime.now();
        String strOpenDateStatusChange = "\"openDateStatusChange\": \"" + openDateStatusChange.format(formatter) + "\"";
        String strVolumeLeft = "\"volumeLeft\": \"" + volumeLeft + "\"";
        String strOpenExpiryDate = "\"openExpiryDate\": \"" + openExpiryDate.format(formatter) + "\"";

        String res = "{" + productInUseId + ","
                + statusId + ","
                + strAvgAmountUse + ","
                + strDateOpen + ","
                + strOpenDateStatusChange + ","
                + strVolumeLeft + ","
                + strOpenExpiryDate
                + "}";
        return res;
    }


    public void initializeProductInUse(TrackedUserProduct newTrackedUserProduct, Product product){
        newTrackedUserProduct.setOpened(true);
        newTrackedUserProduct.setNumProductOpened(newTrackedUserProduct.getNumProductOpened() + 1); //Tổng sản phẩm đã dùng
        newTrackedUserProduct.setDateOpen(LocalDateTime.now()); //Ngày mở mới nhất
        newTrackedUserProduct.setVolumeLeft(newTrackedUserProduct.getVolume()); //Tổng volume còn lại (tính sản phẩm đang mở thôi)

        if(product.getAvgUsageAmount() != 0){ //Không dùng hết trong một lần dùng --> cần track và tính toán volume sử dụng

            if(!product.getDefOpenedExpiredDate().equals("unchanged")){ //Nếu date hết hạn của sản phẩm thay đổi

                String[] givenOpenedExpiredDate = product.getDefOpenedExpiredDate().split(" ");
                String times = givenOpenedExpiredDate[0];
                String period = givenOpenedExpiredDate[1];

                LocalDateTime openExpiryDate = calculateNextOpenExpiredDate(times, period, newTrackedUserProduct.getDateOpen());
                newTrackedUserProduct.setProductsInUse(generateProductInUse(product.getAvgUsageAmount(),
                        newTrackedUserProduct.getDateOpen(), newTrackedUserProduct.getVolumeLeft(), openExpiryDate));

            }
            else{ //Date hết hạn của sản phẩm không thay đổi
                newTrackedUserProduct.setProductsInUse(generateProductInUse(product.getAvgUsageAmount(),
                        newTrackedUserProduct.getDateOpen(), newTrackedUserProduct.getVolumeLeft(), newTrackedUserProduct.getExpiryDate()));
            }
        }
        else { //Dùng hết trong một lần dùng --> chỉ cần trừ quantity
//            newTrackedUserProduct.setNumProductOpened(newTrackedUserProduct.getNumProductOpened() + 1);
            //Không thay đổi quantity, khi tính toán số lượng còn lại (quantityLeft = quantity - numProductOpened)
        }
    }


    @Override
    public TrackedUserProduct toTrackedUserProduct(TrackedUserProductRequest request, Status status, Transaction transaction,
                                                   Product product){

        //Set basic information
        boolean isOpened_bool = request.isOpened();

        TrackedUserProduct newTrackedUserProduct = TrackedUserProduct.builder()
                //Set relationship
                .product(product) //productName
                .transaction(transaction)
                .status(status)
                //Attributes
                .dateBought(parseIntoLocalDate(request.getDateBought()))
                .expiryDate(parseIntoLocalDate(request.getExpiryDate()))
                .dateStatusChange(LocalDateTime.now())
                .peopleUse(request.getPeopleUse())
                .quantity(request.getQuantity())
                .volume(request.getVolume())
                .cost(request.getCost())
                .frequency(request.getFrequency())
                .wayPreserve(request.getWayPreserve())
                .build();

        //Set relationship
//        product.addTrackedUserProduct(newTrackedUserProduct);
//        status.addTrackedUserProduct(newTrackedUserProduct);
//        transaction.addTrackedUserProduct(newTrackedUserProduct);

        //Set in-use product
        if (isOpened_bool){
            initializeProductInUse(newTrackedUserProduct,product);
        }

        return newTrackedUserProduct;
    }

    @Override
    public void updateTrackedUserProduct(TrackedUserProduct needUpdatedtrackedUserProduct, TrackedUserProductUpdateRequest updateRequest){
        needUpdatedtrackedUserProduct.setPeopleUse(updateRequest.getPeopleUse());
        needUpdatedtrackedUserProduct.setFrequency(updateRequest.getFrequency());
        needUpdatedtrackedUserProduct.setOpened(updateRequest.isOpened());

        if(needUpdatedtrackedUserProduct.isOpened()){
            initializeProductInUse(needUpdatedtrackedUserProduct, needUpdatedtrackedUserProduct.getProduct());
        }
    }

    @Override
    public TrackedUserProductResponse toTrackedUserProductResponse(TrackedUserProduct trackedUserProduct){
        TrackedUserProductResponse response = TrackedUserProductResponse.builder()
                .productId(trackedUserProduct.getProduct().getId())
                .transactionId(trackedUserProduct.getTransaction().getTransactionId())
                .productName(trackedUserProduct.getProduct().getProductName())
                .statusName(trackedUserProduct.getStatus().getStatusProductName())
                .categoryName(trackedUserProduct.getProduct().getCategory().getCategoryName())
                .expiryDate(trackedUserProduct.getExpiryDate())
                .quantity(trackedUserProduct.getQuantity())
                .cost(trackedUserProduct.getCost())
                .volume(trackedUserProduct.getVolume())
                .dateBought(trackedUserProduct.getDateBought())
                .peopleUse(trackedUserProduct.getPeopleUse())
                .frequency(trackedUserProduct.getFrequency())
                .wayPreserve(trackedUserProduct.getWayPreserve())
                .isOpened(trackedUserProduct.isOpened())
                .imagePath(trackedUserProduct.getProduct().getImagePath())
                .categoryImagePath(trackedUserProduct.getProduct().getCategory().getImagePath())
                .volumeUnit(trackedUserProduct.getProduct().getVolumeUnit())
                .numberOfProductsHasFinished(trackedUserProduct.getNumProductOpened())
                .build();

        if(trackedUserProduct.isOpened()){
            if(trackedUserProduct.getProductsInUse() == null){ //Những sản phẩm dùng hết liền
                trackedUserProduct.setOpened(false);
                response.setOpened(false);
            }
            else {  //Những sản phẩm dùng không hết liền
                response.setTrackedUserProductOpened(jsonProductInUse(trackedUserProduct.getProductsInUse()));
            }
        }

        return response;
    }

    public TrackedUserProductOpened jsonProductInUse(String jsonStringProduct){
        JsonObject productInUse = JsonParser.parseString(jsonStringProduct).getAsJsonObject();
        System.out.println(productInUse);
        LocalDateTime dateOpen_ = parseIntoLocalDate(productInUse.get("dateOpen").getAsString());
        int volumeLeft_ = (int) productInUse.get("volumeLeft").getAsDouble();
        LocalDateTime openExpiryDate_ = parseIntoLocalDate(productInUse.get("openExpiryDate").getAsString());
        String statusName_ = productInUse.get("statusName").getAsString();
        LocalDateTime openStatusChangedDate_ = parseIntoLocalDate(productInUse.get("openDateStatusChange").getAsString());

        return  TrackedUserProductOpened.builder()
                .dateOpen(dateOpen_)
                .volumeLeft(volumeLeft_)
                .openExpiryDate(openExpiryDate_)
                .statusName(statusName_)
                .openStatusChangedDate(openStatusChangedDate_)
                .build();
    }
}
