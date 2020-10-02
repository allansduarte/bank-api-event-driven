defmodule BankAPI.Accounts.Aggregates.Account.WithdrawAccount do
  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.WithdrawFromAccount
  alias BankAPI.Accounts.Events.WithdrawnFromAccount

  def aggregate do
    quote do
      def execute(
            %Account{uuid: account_uuid, closed?: false, current_balance: current_balance},
            %WithdrawFromAccount{account_uuid: account_uuid, withdraw_amount: amount}
          ) do
        if current_balance - amount > 0 do
          %WithdrawnFromAccount{
            account_uuid: account_uuid,
            new_current_balance: current_balance - amount
          }
        else
          {:error, :insufficient_funds}
        end
      end

      def execute(
            %Account{uuid: account_uuid, closed?: true},
            %WithdrawFromAccount{account_uuid: account_uuid}
          ) do
        {:error, :account_closed}
      end

      def execute(
            %Account{},
            %WithdrawFromAccount{}
          ) do
        {:error, :not_found}
      end

      def apply(
            %Account{
              uuid: account_uuid,
              current_balance: _current_balance
            } = account,
            %WithdrawnFromAccount{
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
