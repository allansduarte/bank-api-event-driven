defmodule BankAPI.Accounts.Aggregates.Account.DepositAccount do
  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.DepositIntoAccount
  alias BankAPI.Accounts.Events.DepositedIntoAccount

  def aggregate do
    quote do
      def execute(
            %Account{uuid: account_uuid, closed?: true},
            %DepositIntoAccount{account_uuid: account_uuid}
          ) do
        {:error, :account_closed}
      end

      def execute(
            %Account{},
            %DepositIntoAccount{}
          ) do
        {:error, :not_found}
      end

      def apply(
            %Account{
              uuid: account_uuid,
              current_balance: _current_balance
            } = account,
            %DepositedIntoAccount{
              account_uuid: account_uuid,
              new_current_balance: new_current_balance
            }
          ) do
        %Account{
          account
          | current_balance: new_current_balance
        }
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
