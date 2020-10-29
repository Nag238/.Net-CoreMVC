CREATE DATABASE Team4DB

GO

USE Team4DB

GO

CREATE TABLE [dbo].[Customer] (
    [SSN]        INT          NOT NULL,
    [CustomerId] INT          IDENTITY (100000000, 1) NOT NULL,
    [Name]       VARCHAR (20) NULL,
    [Address]    VARCHAR (50) NULL,
    [Age]        INT          NULL,
    PRIMARY KEY CLUSTERED ([CustomerId] ASC),
    UNIQUE NONCLUSTERED ([SSN] ASC),
    CHECK (len([SSN])=(9)),
    CHECK (len([SSN])=(9))
);

GO

CREATE TABLE [dbo].[AccountStatus] (
    [AccountId]   INT           IDENTITY (123456789, 1) NOT NULL,
    [CustomerId]  INT           NOT NULL,
    [AccountType] VARCHAR (1)   NULL,
    [Status]      INT           NOT NULL,
    [Message]     VARCHAR (100) NULL,
    [LastUpdated] DATETIME      NULL,
    [Balance]     FLOAT (53)    NULL,
    [CrDate]      DATETIME      NULL,
    [CrLastDate]  DATETIME      NULL,
    [Duration]    INT           NULL,
    PRIMARY KEY CLUSTERED ([AccountId] ASC),
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]) ON DELETE CASCADE,
    CHECK (len([AccountId])=(9)),
    CHECK (len([CustomerId])=(9)),
    CHECK ([AccountType]='S' OR [AccountType]='C'),
    CHECK ([Status]>=(0) AND [Status]<=(1))
);

GO

CREATE TABLE [dbo].[Transactions] (
    [AccountID]       INT         NOT NULL,
    [TransactionId]   INT         IDENTITY (1, 1) NOT NULL,
    [CustomerId]      INT         NOT NULL,
    [TransferAmt]     FLOAT (53)  NULL,
    [WithdrawAmt]     FLOAT (53)  NULL,
    [DepositAmt]      FLOAT (53)  NULL,
    [Amount]          FLOAT (53)  NULL,
    [TransactionDate] DATETIME    NULL,
    [SrcAccType]      VARCHAR (1) NULL,
    [TarAccType]      VARCHAR (1) NULL,
    PRIMARY KEY CLUSTERED ([TransactionId] ASC),
    FOREIGN KEY ([CustomerId]) REFERENCES [dbo].[Customer] ([CustomerId]) ON DELETE CASCADE,
    FOREIGN KEY ([AccountID]) REFERENCES [dbo].[AccountStatus] ([AccountId]),
    CHECK ([SrcAccType]='S' OR [SrcAccType]='C'),
    CHECK ([TarAccType]='S' OR [TarAccType]='C')
);

CREATE TABLE [dbo].[UserStore] (
    [login]     VARCHAR (50) NOT NULL,
    [password]  VARCHAR (50) NULL,
    [timestamp] DATETIME     DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([login] ASC)
);

GO

insert into UserStore(login, password, timestamp) values('admin', 'admin', CURRENT_TIMESTAMP);

GO

