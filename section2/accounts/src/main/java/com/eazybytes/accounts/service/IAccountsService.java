package com.eazybytes.accounts.service;

import com.eazybytes.accounts.dto.CustomerDto;

public interface IAccountsService {

    /*
    *
     @Param customerDto - CustomerDto Object
     */


     void createAccount(CustomerDto customerDto);
}
