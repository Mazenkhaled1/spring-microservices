package com.eazybytes.accounts.service;

import com.eazybytes.accounts.dto.CustomerDto;

public interface IAccountsService {

    /*
    *
     @Param customerDto - CustomerDto Object
     */


     void createAccount(CustomerDto customerDto);

     CustomerDto fetchAccount(String accountNumber);

     boolean updateAccount(CustomerDto customerDto);

     boolean deleteAccount(String accountNumber);

}
