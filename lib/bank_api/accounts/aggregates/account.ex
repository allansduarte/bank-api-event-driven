defmodule BankAPI.Accounts.Aggregates.Account do
  defstruct uuid: nil,
            current_balance: nil,
            closed?: false

  use BankAPI.Accounts.Aggregates.Account.OpenAccount, :aggregate
  use BankAPI.Accounts.Aggregates.Account.CloseAccount, :aggregate
  use BankAPI.Accounts.Aggregates.Account.DepositAccount, :aggregate
  use BankAPI.Accounts.Aggregates.Account.WithdrawAccount, :aggregate
  use BankAPI.Accounts.Aggregates.Account.TransferBetweenAccounts, :aggregate
end
