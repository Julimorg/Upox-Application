package com.UPOX.upox_back_end.component;

import com.UPOX.upox_back_end.service.TrackedUserProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class ScheduledTasks {

    @Autowired
    TrackedUserProductService trackedUserProductService;

    @Scheduled(cron = "0 0 0 1 * ?")
    public void createMonthlyExpense(){
        trackedUserProductService.updateMonthlyExpense();
    }

    @Scheduled(cron = "0 0 0 * * ?")
    public void updateDailyProductStatus(){
        trackedUserProductService.updateDailyProductStatus();
    }

}
