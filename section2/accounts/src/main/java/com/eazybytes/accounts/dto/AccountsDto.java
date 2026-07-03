package com.eazybytes.accounts.dto;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class AccountsDto {


    @NotEmpty(message = "AccountNumber can not be null or empty")
    @Pattern(regexp = "(^$|01[0125][0-9]{8})", message = "Mobile number must be a valid Egyptian number")

    private Long accountNumber;


    @NotEmpty(message = "AccountType can not be null or empty")
    private String accountType;

    @NotEmpty(message = "BranchAddress can not be null or empty")
    private String branchAddress;
}
