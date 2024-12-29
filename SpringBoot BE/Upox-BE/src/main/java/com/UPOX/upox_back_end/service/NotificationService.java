package com.UPOX.upox_back_end.service;

import com.UPOX.upox_back_end.dto.request.FirebaseTokenCreateRequest;
import com.UPOX.upox_back_end.dto.request.NotificationRequest;
import com.UPOX.upox_back_end.dto.response.NotificationResponse;
import com.UPOX.upox_back_end.entity.*;
import com.UPOX.upox_back_end.enums.NotificationBodyE;
import com.UPOX.upox_back_end.enums.NotificationHeaderE;
import com.UPOX.upox_back_end.repository.FirebaseTokenRepository;
import com.UPOX.upox_back_end.repository.NotificationRepository;
import com.UPOX.upox_back_end.repository.UserRepository;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.*;
import com.google.firebase.messaging.Notification;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.annotation.PostConstruct;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.mapstruct.control.MappingControl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;




@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Service
@Slf4j
public class NotificationService {

    @Autowired
    UserRepository userRepository;

    @Autowired
    FirebaseTokenRepository firebaseTokenRepository;

    @Autowired
    NotificationRepository notificationRepository;


    public void processProductMessage(List<TrackedUserProduct>  productsNeededToNotify) throws ExecutionException, InterruptedException {
        for (var product : productsNeededToNotify) {
            //Lấy Firebase token
            String firebaseToken = findUserFirebaseToken(product.getTransaction());
            //Enums cho body notification
            NotificationRequest notificationRequest = chooseTypeOfMessage(product.getStatus().getStatusProductName(),
                    product.getProduct().getProductName());
            assert notificationRequest != null;
            notificationRequest.setToken(firebaseToken);
            sendMessageToToken(notificationRequest);
        }
    }

    public void processOverExpenseMessage(String userName){
        try{
            var toUser = userRepository.findByUsername(userName);
            assert toUser.isPresent();

            String firebaseToken = toUser.get().getFirebaseTokens().get(0).getToken();
            sendMessageToToken(NotificationRequest.builder()
                    .token(firebaseToken)
                    .title(NotificationHeaderE.SPEND_TOO_MUCH.getTitle())
                    .body(NotificationBodyE.SPEND_TOO_MUCH.getContent())
                    .build());
//            if(isSpendTooMuch(toUser.get())){ //Nếu xài quá tay
//                String firebaseToken = toUser.get().getFirebaseTokens().get(0).getToken();
//                sendMessageToToken(NotificationRequest.builder()
//                        .token(firebaseToken)
//                        .title(NotificationHeaderE.SPEND_TOO_MUCH.getTitle())
//                        .body(NotificationBodyE.SPEND_TOO_MUCH.getContent())
//                        .build());
//            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    private boolean isSpendTooMuch(User user){

        double differenceLimit = 0.05; //Chênh lệch %5
        Expense currentExpense = user.getExpenses().get(0);

        long limit = currentExpense.getExpenseLimit();
        long totSpent = currentExpense.getTotMoneySpent();

        double calculateDiff =  (limit - totSpent) / (double) limit;

        return calculateDiff <= differenceLimit;
    }

    private NotificationRequest generateNotificationRequest(NotificationHeaderE header, NotificationBodyE body, String productName){
        body.setProductName(productName);
        body.updateContent();
        return NotificationRequest.builder()
                .title(header.getTitle())
                .body(body.getContent())
                .build();
    }

    private NotificationRequest chooseTypeOfMessage(String productStatus, String productName){
        switch (productStatus) {
            case "MONTH_BEFORE" -> {
                return generateNotificationRequest(NotificationHeaderE.MONTH_BEFORE, NotificationBodyE.MONTH_BEFORE, productName);
            }
            case "SEVEN_DAYS_BEFORE" -> {
                return generateNotificationRequest(NotificationHeaderE.SEVEN_DAYS_BEFORE, NotificationBodyE.SEVEN_DAYS_BEFORE, productName);
            }
            case "THREE_DAYS_BEFORE" -> {
                return generateNotificationRequest(NotificationHeaderE.THREE_DAYS_BEFORE, NotificationBodyE.THREE_DAYS_BEFORE, productName);
            }
            case "SPOILT" -> {
                return generateNotificationRequest(NotificationHeaderE.SPOILT, NotificationBodyE.SPOILT, productName);
            }
            default -> {
                return null;
            }
        }
    }


    private String findUserFirebaseToken(Transaction transaction){
        Expense expense = transaction.getExpense();
        User user = expense.getUser();
        FirebaseToken firebaseToken = user.getFirebaseTokens().get(0);

        return firebaseToken.getToken();
    }

    public void updateFirebaseToken(String userName, FirebaseTokenCreateRequest request){
        try{
            var toUser = userRepository.findByUsername(userName);
            assert toUser.isPresent();
            FirebaseToken token = FirebaseToken.builder()
                    .token(request.getFirebaseToken())
                    .dateIssued(LocalDateTime.now())
                    .user(toUser.get())
                    .build();

            firebaseTokenRepository.save(token);
            firebaseTokenRepository.flush();
        }catch (Exception e){
            e.printStackTrace();
        }
    }


    public void sendMessageToToken(NotificationRequest request)throws InterruptedException, ExecutionException {
        Message message = getPreconfiguredMessageToToken(request);
        Gson gson = new GsonBuilder().setPrettyPrinting().create();
        String jsonOutput = gson.toJson(message);
        String response = sendAndGetResponse(message);
        log.info("Sent message to token. Device token: " + request.getToken() + ", " + response+ " msg "+jsonOutput);

        FirebaseToken firebaseToken = firebaseTokenRepository.findByToken(request.getToken());

        //save notification into db
        notificationRepository.save(com.UPOX.upox_back_end.entity.Notification.builder()
                        .dateSend(LocalDateTime.now())
                        .heading(request.getTopic())
                        .noti_content(request.getBody())
                        .user(firebaseToken.getUser())
                        .type("UNREAD")
                .build());

        //return message response to debug
    }

    private String sendAndGetResponse(Message message) throws InterruptedException, ExecutionException {
        return FirebaseMessaging.getInstance().sendAsync(message).get();
    }

    private AndroidConfig getAndroidConfig(String topic) {
        return AndroidConfig.builder()
                .setTtl(Duration.ofMinutes(2).toMillis()).setCollapseKey(topic)
                .setPriority(AndroidConfig.Priority.HIGH)
                .setNotification(AndroidNotification.builder()
                        .setTag(topic).build()).build();
    }

    private ApnsConfig getApnsConfig(String topic) {
        return ApnsConfig.builder()
                .setAps(Aps.builder().setCategory(topic).setThreadId(topic).build()).build();
    }
    private Message getPreconfiguredMessageToToken(NotificationRequest request) {
        return getPreconfiguredMessageBuilder(request).setToken(request.getToken())
                .build();
    }

    private Message.Builder getPreconfiguredMessageBuilder(NotificationRequest request) {
        AndroidConfig androidConfig = getAndroidConfig(request.getTopic());
        ApnsConfig apnsConfig = getApnsConfig(request.getTopic());
        Notification notification = Notification.builder()
                .setTitle(request.getTitle())
                .setBody(request.getBody())
                .build();
        return Message.builder()
                .setApnsConfig(apnsConfig).setAndroidConfig(androidConfig).setNotification(notification);
    }

    public List<NotificationResponse> getNotifications(String username){
        try{
            var currentUser = userRepository.findByUsername(username);
            assert currentUser.isPresent();

            List<com.UPOX.upox_back_end.entity.Notification> notifications = currentUser.get().getNotifications();

            updateNotificationType(notifications);

            List<NotificationResponse> listNotificationResponse = toNotificationResponse(notifications);

            return listNotificationResponse;

        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    private void updateNotificationType(List<com.UPOX.upox_back_end.entity.Notification> notifications){
        if (notifications.size() > 0){
            for (var notification:notifications) {
                if(notification.getType().equals("UNREAD")){
                    notification.setType("READ");
                    notificationRepository.save(notification);
                }
            }
        }
    }
    private List<NotificationResponse> toNotificationResponse(List<com.UPOX.upox_back_end.entity.Notification> notifications){
        List<NotificationResponse> listResponse = new ArrayList<>();

        if(notifications.size() > 0){
            for (var notification:notifications) {
                listResponse.add(NotificationResponse.builder()
                        .dateSend(notification.getDateSend())
                        .heading(notification.getHeading())
                        .noti_content(notification.getNoti_content())
                        .type(notification.getType())
                        .build());
            }
        }
        return  listResponse;
    }
}
