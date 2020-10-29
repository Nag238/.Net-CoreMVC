Stored Procedures:

1.)
CREATE PROCEDURE CreateAccount
	@CustomerId int,
	@AccountType varchar(1),
	@Status int,
	@Message varchar(100),
	@LastUpdated DATETIME,
	@Balance Float,
	@CRDate DATETIME,
	@CRLastDate DateTime,
	@Duration int
AS

	if exists(
	select *
	from Customer
	where CustomerId = @CustomerId)
	BEGIN
    insert into AccountStatus(CustomerId, AccountType, Status, Message, LastUpdated, Balance, CrDate, CrLastDate, Duration) 
    values (
	@CustomerId ,
	@AccountType,
	@Status ,
	@Message ,
	@LastUpdated ,
	@Balance,
	@CRDate,
	@CRLastDate,
	@Duration)
END

2.)

CREATE PROCEDURE CreateCustomer
    @SSN int ,
    @Name varchar(20),
    @Address varchar(50),
    @Age int
AS
BEGIN

    insert into Customer(SSN, Name, Address, Age) 
    values (@SSN, @Name, @Address, @Age)
END

3.)

CREATE PROCEDURE DeleteAccount
	@CustomerId INT
AS

if exists(
select *
from AccountStatus
where CustomerId = @CustomerId)
begin

delete from AccountStatus
where CustomerId = @CustomerId

end

4.)

CREATE PROCEDURE DeleteCustomer
	@CustomerId INT
AS

if exists(
select *
from Customer 
where CustomerId = @CustomerId)
begin

delete from Customer
where CustomerId = @CustomerId

end

5.)

CREATE PROCEDURE Deposit
	@DepositAmt float,
	@CustomerId int
AS
if exists(
select *
from AccountStatus
where CustomerId = @CustomerId)
begin


update AccountStatus
set Balance = @DepositAmt + Balance
where  CustomerId = @CustomerId

insert into Transactions(CustomerId, AccountId,TransferAmt, WithdrawAmt, DepositAmt, Amount, TransactionDate, SrcAccType, TarAccType)
values( @CustomerId, (Select AccountId FROM AccountStatus where CustomerId = @CustomerId),NULL,
null, @DepositAmt, (Select Balance from AccountStatus where CustomerId = @CustomerId), Current_timestamp, null, null)

end

RETURN 0

6.)


CREATE PROCEDURE GetStatement
	@AccountId int,
	@NumToDisplay INTEGER
		
AS
if exists(
    select *
    from AccountStatus
	where AccountId = @AccountId
) 
begin

select top (@NumToDisplay) *
from Transactions 
where AccountId = @AccountId


END
RETURN 0

7.)

CREATE PROCEDURE RetrieveAccountDetails
 @CustomerId INT
AS
BEGIN
    select *
    from AccountStatus
	where CustomerId = @CustomerId

   
RETURN 0
END

8.)

CREATE PROCEDURE Transfer
	@TransferAmt float,
	@SrcAccountId int,
	@DestAccountId int
AS
if exists(
select *
from AccountStatus
where CustomerId = @SrcAccountId 
) and
exists(
select *
from AccountStatus
where CustomerId = @DestAccountId 
)

update AccountStatus
set Balance = Balance - @TransferAmt
where  CustomerId = @SrcAccountId

update AccountStatus
set Balance = Balance + @TransferAmt
where  CustomerId = @DestAccountId

insert into Transactions(CustomerId, AccountId,TransferAmt, WithdrawAmt, DepositAmt, Amount, TransactionDate, SrcAccType, TarAccType)
values( @SrcAccountId, (Select AccountId FROM AccountStatus where CustomerId = @SrcAccountId), @TransferAmt,
null, null, (Select Balance from AccountStatus where CustomerId = @SrcAccountId), Current_timestamp, (select AccountType from AccountStatus where CustomerId = @SrcAccountId),
(select AccountType from AccountStatus where CustomerId = @DestAccountId))


RETURN 0

9.)

CREATE PROCEDURE UpdateCustomerUsingId
	@CustomerId INT,
	@Name varchar(20),
	@Address varchar(50),
	@Age int
AS

if exists(
select *
from Customer 
where CustomerId = @CustomerId)

BEGIN

update Customer
set Name = @Name
where  CustomerId = @CustomerId

update Customer
set Address = @Address
where  CustomerId = @CustomerId

update Customer
set Age = @Age
where  CustomerId = @CustomerId

RETURN 0
END

10.)

CREATE PROCEDURE ViewCustomers
    @CustomerId INT
AS
BEGIN
    select *
    from Customer
    where CustomerId = @CustomerId
RETURN 0
END

11.)

CREATE PROCEDURE Withdraw
	@WithdrawAmt float,
	@CustomerId int
AS
if exists(
select *
from AccountStatus
where CustomerId = @CustomerId)
begin


update AccountStatus
set Balance = Balance - @WithdrawAmt
where  CustomerId = @CustomerId

insert into Transactions(CustomerId, AccountId,TransferAmt, WithdrawAmt, DepositAmt, Amount, TransactionDate, SrcAccType, TarAccType)
values( @CustomerId, (Select AccountId FROM AccountStatus where CustomerId = @CustomerId),NULL,
@WithdrawAmt, null, (Select Balance from AccountStatus where CustomerId = @CustomerId), Current_timestamp, null, null)

end

RETURN 0
