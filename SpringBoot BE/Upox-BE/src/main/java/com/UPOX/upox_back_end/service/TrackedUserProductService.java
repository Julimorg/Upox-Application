package com.UPOX.upox_back_end.service;


import com.UPOX.upox_back_end.dto.request.CheckProductExistRequest;
import com.UPOX.upox_back_end.dto.request.TrackedUserProductListRequest;
import com.UPOX.upox_back_end.dto.request.TrackedUserProductRequest;
import com.UPOX.upox_back_end.dto.request.TrackedUserProductUpdateRequest;
import com.UPOX.upox_back_end.dto.response.*;
import com.UPOX.upox_back_end.entity.*;
import com.UPOX.upox_back_end.enums.StatusE;
import com.UPOX.upox_back_end.exception.ErrorCode;
import com.UPOX.upox_back_end.model.*;
import com.UPOX.upox_back_end.model.IdClass.TrackedUserProductID;

import com.UPOX.upox_back_end.repository.*;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.chrono.ChronoLocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;


import org.springframework.transaction.annotation.Transactional;


@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Service
@Slf4j
public class TrackedUserProductService {

    @Autowired
    private TrackedUserProductRepository trackedUserProductRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StatusRepository statusRepository;

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private  ExpenseRepository expenseRepository;

    private Mapper trackedProducMapper = new Mapper();

    private void addHistoryProduct(List<Transaction> transactions, Set<String> historyProductList, int sizeLimit){
        List<TrackedUserProduct> userProducts = new ArrayList<>();

        for (var transaction: transactions) {
            userProducts.addAll(transaction.getTrackedUserProducts());
        }

        for(var product:userProducts){
            if(historyProductList.size() < sizeLimit){
                historyProductList.add(product.getProduct().getProductName());
            }
            else{
                break;
            }
        }
    }

    public MyHistoryProductResponse getMyProductHistory(String username) {
        try {
            var currentUser = userRepository.findByUsername(username);
            assert currentUser.orElse(null) != null;
            List<Expense> listHistoryExpense = currentUser.get().getExpenses();

            //Lấy đủ 10 product trong 2 tháng gần đây
            int sizeLimit = 10;


            //Lấy 2 tháng expense gần nhất
            Expense expenseCurrentMonth = listHistoryExpense.size() > 0 ? listHistoryExpense.get(0) : null;
            Expense expensePreviousMonth = listHistoryExpense.size() > 1 ? listHistoryExpense.get(1) : null;

//            assert expenseCurrentMonth != null;
//            assert expensePreviousMonth != null;

            List<Transaction> transactionCurrentMonth = expenseCurrentMonth != null ?
                    expenseCurrentMonth.getTransactions() : new ArrayList<>();


            List<Transaction> transactionPreviousMonth = expensePreviousMonth != null ?
                    expensePreviousMonth.getTransactions() : new ArrayList<>();

            //Xét các products trong các transactions của tháng đầu tiên
            Set<String> historyProductList = new HashSet<>();
            addHistoryProduct(transactionCurrentMonth,historyProductList,sizeLimit);

            //Xét các products trong các transactions của tháng trước đó
            if(historyProductList.size() < sizeLimit){ //Nếu sản phẩm hiển thị vẫn chưa đủ
                addHistoryProduct(transactionPreviousMonth,historyProductList,sizeLimit);
            }

            return MyHistoryProductResponse.builder()
                    .trackedUserProductList(historyProductList)
                    .build();
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    public ProductResponse checkProductExist(CheckProductExistRequest request) {
        //Xử lý chuỗi
        //Tìm trên DB

        List<Product> listDefProduct = productRepository.findAll();

        Product foundProduct = new Product();
        for (var product : listDefProduct) {
            log.info(product.getProductName());
            String defProductName = product.getProductName().toUpperCase(Locale.ROOT);
            String addProductName = request.getProductName().toUpperCase(Locale.ROOT);

            if (addProductName.contains(defProductName)) {
                foundProduct = product;
                break;
            }
        }


        return ProductResponse.builder()
                .productName(foundProduct.getProductName())
                .defPreserveWay(foundProduct.getDefPreserveWay())
                .defCost(foundProduct.getDefCost())
                .defExpiryDate(foundProduct.getDefExpiryDate())
                .defVolume(foundProduct.getDefVolume())
                .imagePath(foundProduct.getImagePath())
                .build();
    }


    private Optional<TrackedUserProduct> findUserProduct(String productId, String transactionId){
        try {
            var foundProduct = productRepository.findById(productId);
            var foundTransaction = transactionRepository.findById(transactionId);
            assert foundProduct.orElse(null) != null;
            assert foundTransaction.orElse(null) != null;

            var needUpdatedTrackedProduct = trackedUserProductRepository.findById(
                    new TrackedUserProductID(foundTransaction.get(),foundProduct.get()));

            assert needUpdatedTrackedProduct.orElse(null) != null;

            return needUpdatedTrackedProduct;
        }catch (Exception e){
            e.printStackTrace();
            throw e;
        }
    }


    @Transactional
    public TrackedUserProductResponse finishUsingProduct(String productId, String transactionId){
        try{

            var needUpdatedTrackedProduct = findUserProduct(productId,transactionId);

            assert needUpdatedTrackedProduct.orElse(null) != null;
            var product = needUpdatedTrackedProduct.get().getProduct();
            int afterFinishing_ProductNumberOpened = needUpdatedTrackedProduct.get().getNumProductOpened();


            int afterFinishing_VolumeLeft = 0;
            boolean afterFinishing_IsOpen = false;
            String afterFinishing_ProductInUse = "";

//            if(isKeepUsing){
//                afterFinishing_VolumeLeft = needUpdatedTrackedProduct.get().getVolume();
//                afterFinishing_IsOpen = true;
//                trackedProducMapper.initializeProductInUse(needUpdatedTrackedProduct.get(),product);
//                afterFinishing_ProductNumberOpened = needUpdatedTrackedProduct.get().getNumProductOpened();
//                afterFinishing_ProductInUse = needUpdatedTrackedProduct.get().getProductsInUse();
//            }

//            needUpdatedTrackedProduct.get().setQuantity(afterFinishing_ProductQuantity);
            needUpdatedTrackedProduct.get().setNumProductOpened(afterFinishing_ProductNumberOpened);
            needUpdatedTrackedProduct.get().setVolumeLeft(afterFinishing_VolumeLeft);
            needUpdatedTrackedProduct.get().setOpened(afterFinishing_IsOpen);
            needUpdatedTrackedProduct.get().setDateOpen(null); //LocalDateTime afterFinishing_DateOpen = null;
            needUpdatedTrackedProduct.get().setProductsInUse(afterFinishing_ProductInUse); //Không còn sản phẩm nào được dùng


            trackedUserProductRepository.save(needUpdatedTrackedProduct.get());
            trackedUserProductRepository.flush();

            return trackedProducMapper.toTrackedUserProductResponse(needUpdatedTrackedProduct.get());

        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    @Transactional
    public String deleteProduct(String productId, String transactionId){
        try {
            var deletedProduct = productRepository.findById(productId);
            var deletedTransaction = transactionRepository.findById(transactionId);
            assert deletedProduct.orElse(null) != null;
            assert deletedTransaction.orElse(null) != null;

            var trackedUserProduct = findUserProduct(productId,transactionId);

            assert trackedUserProduct.orElse(null) != null;

            trackedUserProductRepository.deleteByIds(productId,transactionId);
//            trackedUserProductRepository.deleteById(new TrackedUserProductID(deletedTransaction.get(),deletedProduct.get()));
//            trackedUserProductRepository.flush();
        }catch (Exception e){
            e.printStackTrace();
            return ErrorCode.UNCATEGORIZED_EXCEPTION.getMessage();
        }
        return "Deleted Successfully";
    }

    @Transactional
    public TrackedUserProductResponse updateProduct(String productId, String transactionId, TrackedUserProductUpdateRequest updateRequest){
        try {
            var needUpdatedTrackedProduct = findUserProduct(productId,transactionId);

            assert needUpdatedTrackedProduct.orElse(null) != null;

            trackedProducMapper.updateTrackedUserProduct(needUpdatedTrackedProduct.get(),updateRequest);
            TrackedUserProductResponse trackedUserProductResponse = trackedProducMapper.toTrackedUserProductResponse(needUpdatedTrackedProduct.get());

            trackedUserProductRepository.save(needUpdatedTrackedProduct.get());
            trackedUserProductRepository.flush();

            return trackedUserProductResponse;

        }catch (Exception e){
            e.printStackTrace();
        }

        return null;
    }

    @Transactional
    public TrackedUserProductListResponse addProduct(TrackedUserProductListRequest listRequest, Transaction newTransaction, String username) {

        var currentUser = userRepository.findByUsername(username);
        assert currentUser.orElse(null) != null;
        List<Expense> userExpenses = currentUser.get().getExpenses();

        //Lấy ra expense hiện tại
        Expense currentExpense = userExpenses.get(0);


        TrackedUserProductListResponse listResponse = new TrackedUserProductListResponse();
        int totExpense = 0;
        for (var request : listRequest.getRequestList()) {
            var response = takeInfoProduct(request, newTransaction, username);
            listResponse.addResponse(response);
            totExpense = response.getCost();
        }

        //Cập nhật lại chi phí tiêu dùng
        currentExpense.setTotMoneySpent(currentExpense.getTotMoneySpent() + totExpense);
        expenseRepository.save(currentExpense);
        expenseRepository.flush();

        return listResponse;
    }


    public TrackedUserProductResponse takeInfoProduct(TrackedUserProductRequest request, Transaction lookUpTransaction, String userName) {

        try {
            List<Category> categoryList = categoryRepository.findAll();

            Product lookUpproduct = productRepository.findByProductName(request.getProductName())
                    .orElseThrow(() -> new RuntimeException(ErrorCode.UNCATEGORIZED_EXCEPTION.getMessage()));


            //Foreign key
            Status defStatus = statusRepository.findByStatusProductName(StatusE.NORMAL.name())
                    .orElseThrow(() -> new RuntimeException(ErrorCode.UNCATEGORIZED_EXCEPTION.getMessage()));

//            //Take from product
//            Category lookUpCategory = product.getCategory();
//
//            //Cân nhắc chuyển sang mapper cho gọn code
//            //Setup Product Info
//            TrackedUserProduct newTrackedUserProduct = TrackedUserProduct.builder()
////                .user(user) //Tạo Connection
////                .transaction(lookUpTransaction) //Tạo Connection
////                .product(product) //Tạo Connection
////                .status(curStatus) //Tạo Connection
//                    .dateBought(parseIntoLocalDate(request.getDateBought()))
//                    .expiryDate(parseIntoLocalDate(request.getExpiryDate()))
//                    .dateStatusChange(LocalDateTime.now())
//                    .peopleUse(request.getPeopleUse())
//                    .quantity(request.getQuantity())
//                    .volume(request.getVolume())
//                    .cost(request.getCost())
//                    .frequency(request.getFrequency())
//                    .wayPreserve(request.getWayPreserve())
//                    .isNew(true)
//                    .build();
//
//
//            //Tạo Connection
//            product.addTrackedUserProduct(newTrackedUserProduct);
//            curStatus.addTrackedUserProduct(newTrackedUserProduct);
//            lookUpTransaction.addTrackedUserProduct(newTrackedUserProduct);
//
//            String s = "";
//            s += "\nProduct_id1:" + newTrackedUserProduct.getProduct().getId();
//            s += "\nTransaction1:" + newTrackedUserProduct.getTransaction().getTransactionId();
//            System.err.println(s);
//
////        saveOrUpdate(newTrackedUserProduct);
//
//            //Nếu sản phẩm được sử dụng ngay
//            TrackedUserProductOpened newTrackedUserProductOpened = new TrackedUserProductOpened();
//            if (request.isOpened()) {
//                newTrackedUserProduct.setOpened(true);
//                newTrackedUserProduct.setNumProductOpened(request.getNumProductOpened());
//                newTrackedUserProduct.setDateOpen(parseIntoLocalDate(request.getDateOpen()));
//                newTrackedUserProduct.setVolumeLeft(request.getVolume());
//
//                //Tinh chỉnh attribute của class
//                newTrackedUserProductOpened.setNumProductOpened(request.getNumProductOpened());
//                newTrackedUserProductOpened.setDateOpen(parseIntoLocalDate(request.getDateOpen()));
//                newTrackedUserProductOpened.setVolumeLeft(request.getVolume());
//
//                //Thêm vào một thông tin product trong productsInUse
//                if(!product.getDefOpenedExpiredDate().equals("unchanged")){
//
//                    String[] givenOpenedExpiredDate = product.getDefOpenedExpiredDate().split(" ");
//                    String times = givenOpenedExpiredDate[0];
//                    String period = givenOpenedExpiredDate[1];
//
//                    //Calculate the expired date when opening a product
//                    LocalDateTime openExpiryDate = calculateNextOpenExpiredDate(times, period, newTrackedUserProduct.getDateOpen());
//
//
//                    newTrackedUserProduct.setProductsInUse(generateProductInUse(product.getAvgUsageAmount(),
//                            newTrackedUserProduct.getDateOpen(), newTrackedUserProduct.getVolumeLeft(), openExpiryDate));
//
//                }
//
//            } else {
//                newTrackedUserProductOpened.setNumProductOpened(0);
//                newTrackedUserProductOpened.setDateOpen(null);
//                newTrackedUserProductOpened.setVolumeLeft(request.getVolume());
//            }


            //Save vào db

            TrackedUserProduct newTrackedUserProduct = trackedProducMapper.toTrackedUserProduct(request,defStatus,lookUpTransaction,lookUpproduct);
            TrackedUserProductResponse response = trackedProducMapper.toTrackedUserProductResponse(newTrackedUserProduct);

            trackedUserProductRepository.save(newTrackedUserProduct);


            //Tạo TrackedUserProductResponse
            return response;
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    private LocalDateTime parseIntoLocalDate(String date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        return LocalDateTime.parse(date, formatter);
    }

    private LocalDateTime calculateNextOpenExpiredDate(String strTimes, String strPeriod, LocalDateTime dateOpen){
        int times = Integer.parseInt(strTimes);
        LocalDateTime.now();
        LocalDateTime openExpiredDate = switch (strPeriod) {
            case ("year"), ("years") -> dateOpen.plusYears(times);
            case ("month"), ("months") -> dateOpen.plusMonths(times);
            case ("week"), ("weeks") -> dateOpen.plusWeeks(times);
            case ("day"), ("days") -> dateOpen.plusDays(times);
            case ("hour"), ("hours") -> dateOpen.plusHours(times);
            default -> LocalDateTime.now();
        };
        return openExpiredDate;
    }

//    private String generateProductInUse(double avgAmountUse, LocalDateTime dateOpen,
//                                double volumeLeft, LocalDateTime openExpiryDate){
//
//        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
//
//        String id = UUID.randomUUID().toString();
//        String productInUseId = "\"id\": \"" + id + "\"";
//        String statusId = "\"statusId\": \"" + "03ccba7f-6fbd-4b98-a442-120bb35a3219" + "\"";
//        String strAvgAmountUse = "\"avgAmountUse\": \"" + avgAmountUse + "\"";
//        String strDateOpen = "\"dateOpen\": \"" + dateOpen.format(formatter) + "\"";
//
//        LocalDateTime openDateStatusChange = LocalDateTime.now();
//        String strOpenDateStatusChange = "\"openDateStatusChange\": \"" + openDateStatusChange.format(formatter) + "\"";
//        String strVolumeLeft = "\"volumeLeft\": \"" + volumeLeft + "\"";
//        String strOpenExpiryDate = "\"openExpiryDate\": \"" + openExpiryDate.format(formatter) + "\"";
//
//        String res = "\"{" + productInUseId + ","
//                + statusId + ","
//                + strAvgAmountUse + ","
//                + strDateOpen + ","
//                + strOpenDateStatusChange + ","
//                + strVolumeLeft + ","
//                + strOpenExpiryDate + ","
//                + "}\"";
//        return res;
//    }

    public boolean isProductBeenUsing(String productName, String username){
        List<TrackedUserProduct> userProducts = getUserProductList(username);
        for (var product: userProducts) {
            if(product.getProduct().getProductName().equals(productName) && product.isOpened()){
                return true;
            }
        }
        return false;
    }

    public TrackedUserProductListResponse getAllProductSameName(String productName, String username){
        List<TrackedUserProduct> userProducts = getUserProductList(username).stream()
                .filter(trackedUserProduct -> trackedUserProduct.getProduct().getProductName().equals(productName))
                .toList();

        sortExpiredDate(userProducts);
        List<TrackedUserProductResponse> listResponse = new ArrayList<>();

        userProducts.forEach(trackedUserProduct -> {
            listResponse.add(trackedProducMapper.toTrackedUserProductResponse(trackedUserProduct));
        });

        return TrackedUserProductListResponse.builder()
                .responseList(listResponse)
                .build();

    }

    private List<TrackedUserProduct> getUserProductList(String username){

        List<Transaction> userTransactions = new ArrayList<>();
        List<TrackedUserProduct> userProducts = new ArrayList<>();
        List<Product> products = productRepository.findAll();

        //find user
        var currentUser = userRepository.findByUsername(username);
        assert currentUser.orElse(null) != null;

        List<Expense> userExpenses = new ArrayList<>(currentUser.get().getExpenses());

        //Take all transactions
        if(userExpenses.size() > 0){
            for (var expense: userExpenses) {
                userTransactions.addAll(expense.getTransactions());
            }
            if(userTransactions.size() > 0){
                //Take all tracked-user products
                for (var transaction: userTransactions) {
                    userProducts.addAll(transaction.getTrackedUserProducts());
                }
            }
        }

        return userProducts;
    }


    @Transactional
    public void updateProductCategory() {
//        productRepository.deleteAll();
//        categoryRepository.deleteAll();


        List<Category> categoryList = categoryRepository.findAll();
//        List<Product> productList = productRepository.findAll();

//        Product product = productRepository.findByProductName("Kem rửa mặt")
//                .orElseThrow(() -> new RuntimeException(ErrorCode.UNCATEGORIZED_EXCEPTION.getMessage()));

        try {
            var category = categoryRepository.findByCategoryName("Giặt giũ");
        //    Category category = categoryRepository.findById(categoryId)
        //            .orElseThrow(() -> new RuntimeException(ErrorCode.UNCATEGORIZED_EXCEPTION.getMessage()));

            Product product = Product.builder()
                    .defCost("{\n \"common\": [\"200000 ₫\", \"150000 ₫\"],\n \"lessCommon\": [\"500000 ₫\", \"40000 ₫\"]\n}")
                    .defExpiryDate("1 year")
                    .defPreserveWay("Nhiệt độ phòng")
                    .defVolume("{\n \"common\": [\"3.6 l\", \"2.7 l\"],\n \"lessCommon\": [\"2.2 l\", \"2.4 l\"]\n}")
                    .productName("Bột giặt - Nước giặt")
                    .avgUsageAmount(65)
                    .defOpenedExpiredDate("unchanged")
                    .build();

            product.setCategory(category.orElse(null));
            category.get().addProduct(product);

            productRepository.save(product);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Transactional
    public Transaction createTransaction(String username) {
        try {
//            Category newCategory = Category.builder()
////                    .categoryId("e58b330b-2ecd-4969-944e-d5185e1f5535")
//                    .categoryName("Chăm sóc da")
//                    .build();
//
//            categoryRepository.save(newCategory);
////            categoryRepository.flush();
//            return newCategory.getId();

//            var product = productRepository.findById("cabdf61a-b06a-47c1-8914-d3238a95f1f9");
//            log.info(product.get().getCategory().getCategoryName());
//            List<Product> lst = productRepository.findAll();
//            for (var product: lst) {
//                log.info(String.valueOf(product.getCategory()));
//            }

            //Create new Transaction
            LocalDate currentMonthYear = LocalDate.now();
            int currentMonth = currentMonthYear.getMonthValue();
            int currentYear = currentMonthYear.getYear();


            var currentUser = userRepository.findByUsername(username);
            assert currentUser.orElse(null) != null;
            List<Expense> userExpenses = currentUser.get().getExpenses();

            //Lấy ra expense hiện tại
            Expense currentExpense = userExpenses.get(0);

//            for (Expense expense : userExpenses) {
//                if (expense.getDateUpdateLimit().getMonthValue() == currentMonth
//                        && expense.getDateUpdateLimit().getYear() == currentYear) {
//                    currentExpense = expense;
//                }
//            }

            assert currentExpense != null;

            Transaction newTransaction = Transaction.builder()
                    .dateTransaction(LocalDateTime.now())
                    .expense(currentExpense)
                    .build();

            transactionRepository.save(newTransaction);

            currentExpense.getTransactions().sort((obj1, obj2) -> {
                Transaction transaction1 = (Transaction) obj1;
                Transaction transaction2 = (Transaction) obj2;
                if (transaction1.getDateTransaction().isBefore(transaction2.getDateTransaction())) return -1;
                if (transaction1.getDateTransaction().isAfter(transaction2.getDateTransaction())) return 1;
                return 0;
            });


            return newTransaction;

//            productRepository.deleteById("cabdf61a-b06a-47c1-8914-d3238a95f1f9");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    //Set lịch chạy (1 tháng - 1 lần)
    //@Schedule
    @Transactional
    public void updateMonthlyExpense(){
        try {
            List<User> users = userRepository.findAll();
            for (var user : users) {
                createExpense(user.getUsername());
            }

        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void createExpense(String username){
        try {
            var currentUser = userRepository.findByUsername(username);
            LocalDate currentMonthYear = LocalDate.now();
            int currentMonth = currentMonthYear.getMonthValue();
            int currentYear = currentMonthYear.getYear();
            int previousMonth = 0;
            int previousYear = currentYear;

            //Lấy totMoneySpent tháng trước
            if(currentMonth == 1){
                previousMonth = 12;
                previousYear--;
            }


            assert currentUser.orElse(null) != null;
            List<Expense> userExpenses = currentUser.get().getExpenses() == null? new ArrayList<>() : currentUser.get().getExpenses();
            Expense previousExpense = userExpenses.size() > 0 ? userExpenses.get(0) : null;



            Expense newExpense = Expense.builder()
                    .expenseLimit(previousExpense != null? previousExpense.getTotMoneySpent():0)
                    .dateUpdateLimit(LocalDateTime.now())
                    .totMoneySpent(0)
                    .user(currentUser.orElse(null))
                    .build();

            userExpenses.add(newExpense);

            userExpenses.sort((obj1, obj2) -> {
                Expense expense1 = (Expense) obj1;
                Expense expense2 = (Expense) obj2;
                if (expense1.getDateUpdateLimit().isBefore(expense2.getDateUpdateLimit())) return -1;
                if (expense1.getDateUpdateLimit().isAfter(expense2.getDateUpdateLimit())) return 1;
                return 0;
            });

            currentUser.get().setExpenses(userExpenses);

            expenseRepository.save(newExpense);
            expenseRepository.flush();


        }catch (Exception e){
//            log.info("{\n \"common\": [\"3.6 l\", \"2.7 l\"],\n \"lessCommon\": [\"2.2 l\", \"2.4 l\"]\n}");


            e.printStackTrace();
        }
    }

    //Set lịch chạy (1 ngày - 1 lần)
    //@Schedule
    //Chưa code
    @Transactional
    public List<TrackedUserProduct> updateDailyProductStatus(){

        //Code here
        List<TrackedUserProduct> allTrackedUserProducts = trackedUserProductRepository.findAll();
        Map<String, List<TrackedUserProduct>> mp_productsMustBeNotified = new HashMap<String,List<TrackedUserProduct>>();
        List<TrackedUserProduct> productsMustBeNotified = new ArrayList<>();
        LocalDate currentDate = LocalDate.now();

        for (var product : allTrackedUserProducts) { //Sản phẩm đang dùng chưa xử lý cập nhật

            //Update volume left
            TrackedUserProductOpened trackedUserProductOpened = updateVolumeLeft(product);
            Status openedUpdatedStatus = new Status();

            //Unopened
            SafeDate safeDate = calculateSafeDate(product);
            LocalDate unopenedProductSafeDate = safeDate.getUnopenedSafeDate();
            Status unopenedUpdatedStatus = findStatus(product.getExpiryDate(), unopenedProductSafeDate.atStartOfDay(),false);

            //Opened
            if(product.isOpened()){
                LocalDateTime openedProductSafeDate = safeDate.getOpenedSafeDate();
                openedUpdatedStatus = findStatus(trackedUserProductOpened.getOpenExpiryDate(), openedProductSafeDate,true);
            }

            if(!product.getStatus().getStatusProductName().equals(unopenedUpdatedStatus.getStatusProductName())
            || !trackedUserProductOpened.getStatusName().equals(openedUpdatedStatus.getStatusProductName())){ //nếu status thay đổi
                product.setStatus(unopenedUpdatedStatus);
                trackedUserProductRepository.save(product);
                trackedUserProductRepository.flush();
                //Tìm id user
                String userId = findProductBelongTo(product);
                if(!mp_productsMustBeNotified.containsKey(userId)){
                    List<TrackedUserProduct> initial = new ArrayList<>();
                    initial.add(product);
                    mp_productsMustBeNotified.put(userId,initial);
                }
                mp_productsMustBeNotified.get(userId).add(product);
            }
        }

        return productsMustBeNotified;
    }

    private String findProductBelongTo(TrackedUserProduct product){
        return product.getTransaction().getExpense().getUser().getId();
    }


    private Status findStatus(LocalDateTime expiredDate, LocalDateTime safeDate, boolean isInUseProduct){
        //Hiện tại chưa xử lý updateStatus cho productInUse

        LocalDate currentDate = LocalDate.now();
        Duration duration = Duration.between(currentDate,safeDate);
        long daysDifference = duration.toDays();

        boolean isSpoilt = currentDate.isEqual(ChronoLocalDate.from(expiredDate));
        String statusName = calculateStatus(daysDifference, isSpoilt);

        var updatedStatus = statusRepository.findByStatusProductName(statusName);
        assert updatedStatus.orElse(null) != null;
        return updatedStatus.get();
    }

    private String calculateStatus(long daysBetween, boolean isSpoilt){
        if(isSpoilt){
            return StatusE.SPOILT.name();
        }
        else if(daysBetween >= 28 && daysBetween <= 31){
            return StatusE.MONTH_BEFORE.name();
        }
        else if(daysBetween == 7){
            return StatusE.SEVEN_DAYS_BEFORE.name();
        }
        else if(daysBetween == 3){
            return StatusE.THREE_DAYS_BEFORE.name();
        }
        else if(daysBetween <= 0){
            return StatusE.LATE.name();
        }
        else{
            return StatusE.NORMAL.name();
        }
    }

    private void sortExpiredDate(List<TrackedUserProduct> list){
        try{
            list.sort((obj1, obj2) -> {
                TrackedUserProduct trackedUserProduct1 = (TrackedUserProduct) obj1;
                TrackedUserProduct trackedUserProduct2 = (TrackedUserProduct) obj2;
                if (trackedUserProduct1.getExpiryDate().isBefore(trackedUserProduct2.getExpiryDate())) return -1;
                if (trackedUserProduct1.getExpiryDate().isAfter(trackedUserProduct2.getExpiryDate())) return 1;
                return 0;
            });
        }catch (Exception e){
            e.printStackTrace();
        }

    }

    private List<TrackedUserProduct> getTrackedProductByProductId(String productId, List<TrackedUserProduct> myProductList){
         List<TrackedUserProduct> productList = myProductList.stream().filter(trackedUserProduct -> trackedUserProduct.getProduct().getId().equals(productId))
                .toList();

        return productList;
    }

    private void printOut(List<TrackedUserProduct> userProducts){
        for (var product:userProducts) {
            System.out.println(product.getProduct().getId() + " " + product.getProduct().getProductName() + ": " + product.getExpiryDate());
        }
    }

    private void printOutMap(Map<String,Integer> mapProduct){
        mapProduct.forEach((key, value) -> {
            System.out.println("Product Id: " + key);
        });
    }

    public List<TrackedUserProductResponse> toTrackedUserProductResponse(List<TrackedUserProduct> myProductList){
        List<TrackedUserProductResponse> responseList = new ArrayList<>();
        for (var product:myProductList) {
            responseList.add(trackedProducMapper.toTrackedUserProductResponse(product));
        }
        return responseList;
    }

    //Suggestion Category
    public Map<String, Integer> getSuggestionCategories(String username){

        Map<String, Integer> suggestionCategories = new HashMap<>();

        List<TrackedUserProduct> userProducts = getUserProductList(username);
        for (var product : userProducts) {
            String cateName = product.getProduct().getCategory().getCategoryName();
            int count = suggestionCategories.get(cateName) == null ? 0
                    : suggestionCategories.get(cateName);

            suggestionCategories.put(cateName,count + 1);
        }
        return suggestionCategories;
    }

    //Inventory
    public List<TrackedUserProduct> getInitialInventory(String username){
        int limitDisplayedCategory = 5;
        int limitDisplayedProduct = 10;

        List<TrackedUserProduct> userProducts = getUserProductList(username);

        System.out.println("/n");
        printOut(userProducts);

        //Sort by ExpiredDate
        sortExpiredDate(userProducts);

        System.out.println("/n");
        printOut(userProducts);

        Map<String,Integer> mapCategory = new LinkedHashMap<>();//categoryId, số sản phẩm xuất hiện
        Map<String,Integer> mapProduct = new LinkedHashMap<>(); //productId, số sản phẩm xuất hiện

        List<TrackedUserProduct> mostEmergencyProduct = new ArrayList<>();

        for (var product:userProducts) {
            if(mapProduct.size() == limitDisplayedProduct || mapCategory.size() == limitDisplayedCategory){
                break;
            }
            //Cập nhật số product đã add
            String addedProductId = product.getProduct().getId();
            int numberAddedProducts = mapProduct.get(addedProductId) == null ? 0 : mapProduct.get(addedProductId);
            mapProduct.put(addedProductId,numberAddedProducts + 1);

            //Cập nhật số category đã add
            String addedCategoryId = product.getProduct().getCategory().getId();
            int numberAddedCategories = mapCategory.get(addedCategoryId) == null ? 0 : mapCategory.get(addedCategoryId);
            mapCategory.put(addedCategoryId,numberAddedCategories + 1);
        }

        printOutMap(mapProduct);

        for (String productId : mapProduct.keySet()) {
            mostEmergencyProduct.addAll(getTrackedProductByProductId(productId,userProducts));
        }

        System.out.println("/n");
        printOut(mostEmergencyProduct);

        //Mapper to TrackedUserProductResponseList
        return mostEmergencyProduct;
    }

    //Chưa code
    public List<TrackedUserProductResponse> getWithConditionInventory(String username, String categories, String status, String lateness
        , String searchValue, String sortBy, boolean isAscending){
        List<TrackedUserProduct> initialInventory = new ArrayList<>();

        System.out.println("In");

        //Nếu không có category hoặc sản phẩm nào cụ thể, lấy initial product list
        if(searchValue.equals("null") && categories.equals("null")){
            initialInventory = getInitialInventory(username);
        }
        //Search
        //Chọn category mới
        //--> Tìm product theo đó
        else if(!searchValue.equals("null")){ //Search

            initialInventory = getUserProductList(username).stream()
                    .filter(trackedUserProduct -> trackedUserProduct.getProduct().getProductName().toUpperCase(Locale.ROOT).contains(searchValue.toUpperCase(Locale.ROOT)))
                    .toList();
            return toTrackedUserProductResponse(initialInventory);
        }
        else{ //categories true
            //categories = "name-name-name-name" limit (5 categories picking)

            String[] chosenCategories = categories.split("-",5);
            for (String chosenCategory : chosenCategories) {
                initialInventory.addAll(getUserProductList(username).stream()
                        .filter(trackedUserProduct ->
                                trackedUserProduct.getProduct().getCategory().getCategoryName().equals(chosenCategory))
                        .toList()
                );
            }
        }

        //status
        if(!status.equals("null")){
            Set<String> productIds = new HashSet<>();
            String[] chosenStatus = status.split("-",3);
            for (String status_ : chosenStatus) {
                if(status_.equals("IN_USE")){
                    initialInventory.forEach(trackedUserProduct -> {
                        if (trackedUserProduct.isOpened()){
                            productIds.add(trackedUserProduct.getProduct().getId());
                        }
                    });
                }
                else{ //STATUS
                    //Lấy status ra
                    //LATE
                    //SPOILT
                    initialInventory.forEach(trackedUserProduct -> {
                        if (trackedUserProduct.getStatus().getStatusProductName().equals(status_)){
                            productIds.add(trackedUserProduct.getProduct().getId());
                        }
                    });
                }
            }
            List<TrackedUserProduct> tempInitalList = new ArrayList<>();
            for (var productId: productIds) {
                tempInitalList.addAll(getTrackedProductByProductId(productId,initialInventory));
            }
            initialInventory = tempInitalList;
        }

        //lateness
        if(!lateness.equals("null")){
            Set<String> productIds = new HashSet<>();
            String[] chosenLateness = lateness.split("-",3);
            for (String lateness_ : chosenLateness) { //STATUS
                //MONTH_BEFORE
                //SEVEN_DAYS_BEFORE
                //THREE_DAYS_BEFORE

                initialInventory.forEach(trackedUserProduct -> {
                    if (trackedUserProduct.getStatus().getStatusProductName().equals(lateness_)){
                        productIds.add(trackedUserProduct.getProduct().getId());
                    }
                });
            }
            List<TrackedUserProduct> tempInitalList = new ArrayList<>();
            for (var productId: productIds) {
                tempInitalList.addAll(getTrackedProductByProductId(productId,initialInventory));
            }
            initialInventory = tempInitalList;
        }

        //sort by

        if(!sortBy.equals("null")){
            if(sortBy.equals("EXPIRED_DATE")){
                initialInventory.sort((obj1, obj2) -> {
                    TrackedUserProduct trackedUserProduct1 = (TrackedUserProduct) obj1;
                    TrackedUserProduct trackedUserProduct2 = (TrackedUserProduct) obj2;
                    if (trackedUserProduct1.getExpiryDate().isBefore(trackedUserProduct2.getExpiryDate())) return isAscending? -1 : 1;
                    if (trackedUserProduct1.getExpiryDate().isAfter(trackedUserProduct2.getExpiryDate())) return isAscending? 1 : -1;
                    return 0;
                });
            }
            else if(sortBy.equals("QUANTITY")){
                initialInventory.sort((obj1, obj2) -> {
                    TrackedUserProduct trackedUserProduct1 = (TrackedUserProduct) obj1;
                    TrackedUserProduct trackedUserProduct2 = (TrackedUserProduct) obj2;
                    if (trackedUserProduct1.getQuantity() < trackedUserProduct2.getQuantity()) return isAscending? -1 : 1;
                    if (trackedUserProduct1.getQuantity() > trackedUserProduct2.getQuantity()) return isAscending? 1 : -1;
                    return 0;
                });
            }
        }

        return toTrackedUserProductResponse(initialInventory);
    }

    //Calendar
    public TrackedCalendarProductResponse getCalenderStatus(String username, int month, int year){
        List<TrackedUserProduct> userProducts = getUserProductList(username);
        return TrackedCalendarProductResponse.builder()
                .calendarProductList(chooseCalendarProducts(userProducts,month,year))
                .build();
    }

    private List<TrackedCalendarProduct> chooseCalendarProducts(List<TrackedUserProduct> userProducts, int month, int year){
        List<TrackedCalendarProduct> chosenCalendarProducts = new ArrayList<>();
        for (var product:userProducts) {

            //Xét hiển thị trên lịch dựa trên tình trạng của sản phẩm chưa mở (phase hiện tại)
            LocalDate unopenedSafeDate = calculateSafeDate(product).getUnopenedSafeDate();
            chosenCalendarProducts.addAll(productsInCalendar(product, month, year, unopenedSafeDate));
        }
        //Sort by dateDisplay
        chosenCalendarProducts.sort((obj1, obj2) -> {
            TrackedCalendarProduct calendarProduct1 = (TrackedCalendarProduct) obj1;
            TrackedCalendarProduct calendarProduct2 = (TrackedCalendarProduct) obj2;
            if (calendarProduct1.getDateDisplay().isBefore(calendarProduct2.getDateDisplay())) return -1;
            if (calendarProduct1.getDateDisplay().isAfter(calendarProduct2.getDateDisplay())) return 1;
            return 0;
        });
        return chosenCalendarProducts;
    }


    //Chỉ đang hiển thị sản phẩm chưa dùng
    private SafeDate calculateSafeDate(TrackedUserProduct calculatedTrackedProduct){ //Trả về 2 ngày "an toàn" : "sản phẩm chưa mở" và "sản phẩm đã mở"
        LocalDate unopenedProductSafeDate;
        LocalDateTime openedProductSafeDate = null;

        LocalDate unopenedExpiryDate = calculatedTrackedProduct.getExpiryDate().toLocalDate();
        int numProductUsed = calculatedTrackedProduct.isOpened() ? (calculatedTrackedProduct.getNumProductOpened() - 1) : (calculatedTrackedProduct.getNumProductOpened());
        int quantity = calculatedTrackedProduct.getQuantity() - numProductUsed;
        int volume = calculatedTrackedProduct.getVolume();

        //Calculation
        int totVolume = quantity * volume;
        double amountUsagePerDay = calculateAvgAmountPerDay(calculatedTrackedProduct);
        int daysNeedToFinish = (int) Math.ceil(totVolume/amountUsagePerDay); //Số ngày có thể hoàn thành xong (làm tròn lên) (ít nhất 1 ngày)
        unopenedProductSafeDate = unopenedExpiryDate.minusDays(daysNeedToFinish);

        if(calculatedTrackedProduct.isOpened()){ //Có sản phẩm đã mở nắp
            log.info(calculatedTrackedProduct.getProduct().getProductName());
            TrackedUserProductOpened calculatedOpenedProduct = trackedProducMapper.jsonProductInUse(calculatedTrackedProduct.getProductsInUse());
            LocalDateTime openedExpiryDate = calculatedOpenedProduct.getOpenExpiryDate();
            int volumeLeft = calculatedOpenedProduct.getVolumeLeft(); //Đã được cập nhật mỗi ngày

            int daysFinishOpenedProduct = (int) Math.ceil(volumeLeft/amountUsagePerDay); //Số ngày có thể hoàn thành xong (làm tròn lên) (ít nhất 1 ngày)
            openedProductSafeDate = openedExpiryDate.minusDays(daysFinishOpenedProduct);
        }

        return SafeDate.builder()
                .unopenedSafeDate(unopenedProductSafeDate)
                .openedSafeDate(openedProductSafeDate)
                .build();
    }


    private double calculateAvgAmountPerDay(TrackedUserProduct trackedUserProduct){
        String[] givenFrequency = trackedUserProduct.getFrequency().split("/");
        double useTimes = Double.parseDouble(givenFrequency[0]);
        double days = Double.parseDouble(givenFrequency[1]);
        double frequency = useTimes/days;
        int numberOfPeople =  trackedUserProduct.getPeopleUse();
        double avgUsageAmount = trackedUserProduct.getProduct().getAvgUsageAmount();
        if(avgUsageAmount == 0){
            avgUsageAmount = trackedUserProduct.getVolume();
        }
        return (frequency * numberOfPeople * avgUsageAmount);
    }


    @Transactional
    public TrackedUserProductOpened updateVolumeLeft(TrackedUserProduct trackedUserProduct){
        if(trackedUserProduct.isOpened()){
            TrackedUserProductOpened trackedOpenedProduct = trackedProducMapper.jsonProductInUse(trackedUserProduct.getProductsInUse());
            double amountUsagePerDay = calculateAvgAmountPerDay(trackedUserProduct);
            int oldVolumeLeft = trackedOpenedProduct.getVolumeLeft();
            int newVolumeLeft = (int) Math.ceil(oldVolumeLeft - amountUsagePerDay);
            String newProductInUse = trackedProducMapper.generateProductInUse(amountUsagePerDay,trackedOpenedProduct.getDateOpen(),
                    newVolumeLeft,trackedOpenedProduct.getOpenExpiryDate());
            trackedUserProduct.setProductsInUse(newProductInUse);
            trackedUserProductRepository.save(trackedUserProduct);
            trackedUserProductRepository.flush();
            return trackedOpenedProduct;
        }
        return null;
    }



    private List<TrackedCalendarProduct> productsInCalendar(TrackedUserProduct userProduct, int month, int year, LocalDate safeDate){

        List<TrackedCalendarProduct> calendarProducts = new ArrayList<>();

        List<Integer> checkedDates = Arrays.asList(30,7,3,0);
        Map<Integer, String> statusDisplay = new HashMap<>();

        statusDisplay.put(30,StatusE.MONTH_BEFORE.name());
        statusDisplay.put(7,StatusE.SEVEN_DAYS_BEFORE.name());
        statusDisplay.put(3,StatusE.THREE_DAYS_BEFORE.name());
        statusDisplay.put(0,StatusE.LATE.name());
        statusDisplay.put(-1,StatusE.SPOILT.name());


        LocalDate expiredDate = userProduct.getExpiryDate().toLocalDate();

        for(var days:checkedDates){ //30 ngày, 7 ngày, 3 ngày, 0 ngày trước safeDate
            int checkedMonth = safeDate.minusDays(days).getMonthValue();
            int checkedYear = safeDate.minusDays(days).getYear();

            if(checkedMonth == month && checkedYear == year){
                calendarProducts.add(TrackedCalendarProduct.builder()
                        .trackedUserProduct(trackedProducMapper.toTrackedUserProductResponse(userProduct))
                        .dateDisplay(safeDate.minusDays(days))
                        .statusDisplay(statusDisplay.get(days))
                        .build());
            }
        }
        if(expiredDate.getMonthValue() == month && expiredDate.getYear() == year){ //Sản phẩm hết hạn (hiếm)
            calendarProducts.add(TrackedCalendarProduct.builder()
                    .trackedUserProduct(trackedProducMapper.toTrackedUserProductResponse(userProduct))
                    .dateDisplay(expiredDate)
                    .statusDisplay(statusDisplay.get(-1))
                    .build());
        }

        return calendarProducts;
    }


    //Expense
    public ExpenseResponse getExpense(String username, int month, int year){
        try{
            var currentUser = userRepository.findByUsername(username);
            assert currentUser.orElse(null) != null;

            Expense calculatedExpense = currentUser.get().getExpenses()
                    .stream().filter(expense -> expense.getDateUpdateLimit().getMonthValue() == month
                    && expense.getDateUpdateLimit().getYear() == year)
                    .findFirst()
                    .orElseThrow();

            long totExpense = 0;

            List<TrackedUserProduct> userProducts = new ArrayList<>();
            for(var transaction: calculatedExpense.getTransactions()){
                userProducts.addAll(transaction.getTrackedUserProducts());
            }

            Map<String, Integer> mapCalculatedCategory = new HashMap<>();

            for(var userProduct:userProducts){
                String categoryName = userProduct.getProduct().getCategory().getCategoryName() + "-"
                        + userProduct.getProduct().getCategory().getImagePath();

                int costOfCategory = mapCalculatedCategory.get(categoryName) == null ? 0
                        : mapCalculatedCategory.get(categoryName);

                totExpense += costOfCategory + (long)userProduct.getCost() * userProduct.getQuantity();

                mapCalculatedCategory.put(categoryName,costOfCategory + userProduct.getCost() * userProduct.getQuantity()); // {Tên category: Tiền đã chi}
            }

            return ExpenseResponse.builder()
                    .categorizedExpense(mapCalculatedCategory) //Map<tên category, tiền đã chi>: tên category: categoryName-imagePath
                                                                //List<String>cate = categoryName.split("-");
                                                                //cate[0]: tên
                                                                //cate[1]: imagePath
                    .limit(calculatedExpense.getExpenseLimit()) //Định mức
                    .totSpent(totExpense) //Tổng tiền chi
                    .build();
        }catch (Exception e){
            e.printStackTrace();
            return ExpenseResponse.builder()
                    .categorizedExpense(new HashMap<>())
                    .build();
        }
    }

    public void readJsonString(){
        String jsonString = "{\"name\":\"John\", \"age\":30, \"city\":\"New York\"}";

        // Phân tích cú pháp chuỗi JSON
        JsonElement jsonElement = JsonParser.parseString(jsonString);

        // Chuyển đổi thành JsonObject
        JsonObject jsonObject = jsonElement.getAsJsonObject();

        // Lấy thông tin từ JsonObject
        String name = jsonObject.get("name").getAsString();
        int age = jsonObject.get("age").getAsInt();
        String city = jsonObject.get("city").getAsString();

        // In ra kết quả
        System.out.println("Name: " + name);
        System.out.println("Age: " + age);
        System.out.println("City: " + city);
    }

    public List<WarningCategory> getWarningCategories(String username){
        int limitCategories = 4;
        int count = 0;
        String currentCategory = "";
        List<TrackedUserProduct> userProducts = getUserProductList(username);
        List<WarningCategory> warningCategories = new ArrayList<>();

        if(userProducts.size() > 0){
            for (var trackedProduct : userProducts) {
                String checkedCategory = trackedProduct.getProduct().getCategory().getCategoryName();
                if(!currentCategory.equals(checkedCategory)){
                    if(!trackedProduct.getStatus().getStatusProductName().equals(StatusE.NORMAL.name())){
                        //change current category
                        currentCategory = checkedCategory;
                        //add vào list
                        warningCategories.add(WarningCategory.builder()
                                .categoryName(trackedProduct.getProduct().getCategory().getCategoryName())
                                .imagePath(trackedProduct.getProduct().getCategory().getImagePath())
                                .statusName(trackedProduct.getStatus().getStatusProductName())
                                .build());
                        count++;
                        if(count == limitCategories){
                            return warningCategories;
                        }
                    }
                }
            }
        }
        return warningCategories;
    }

}
