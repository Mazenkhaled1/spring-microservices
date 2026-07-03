package com.eazybytes.accounts.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class CustomerDto {


    @NotEmpty(message = "Name cannot be null or empty")
    @Size(min = 5 , max = 30 , message = " the length of the customer name should be between 5 and 30")
    private String name;

    @NotEmpty(message = "Email cannot be null or empty")
    @Email(message = "Email address should be a valid value")
    private String email;

    @Pattern(regexp = "(^$|01[0125][0-9]{8})", message = "Mobile number must be a valid Egyptian number")
    private String mobileNumber;

    private AccountsDto accountsDto;
}
