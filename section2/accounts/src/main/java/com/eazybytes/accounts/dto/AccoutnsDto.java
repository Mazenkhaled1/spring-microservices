package com.eazybytes.accounts.dto;

import jakarta.persistence.Column;
import jakarta.persistence.Id;
import lombok.Data;

@Data
public class AccoutnsDto {

    private Long accountNumber;
    private String accountType;
    private String branchAddress;
}
