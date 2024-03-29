defmodule BankAPI.Accounts.Aggregates.Account.OpenAccount do
  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.OpenAccount
  alias BankAPI.Accounts.Events.AccountOpened

  def aggregate do
    quote do
      def execute(
            %Account{uuid: nil},
            %OpenAccount{
              account_uuid: account_uuid,
              initial_balance: initial_balance
            }
          )
          when initial_balance > 0 do
        %AccountOpened{
          account_uuid: account_uuid,
          initial_balance: initial_balance
        }
      end

      def execute(
            %Account{uuid: nil},
            %OpenAccount{
              initial_balance: initial_balance
            }
          )
          when initial_balance <= 0 do
        {:error, :initial_balance_must_be_above_zero}
      end

      def execute(%Account{}, %OpenAccount{}) do
        {:error, :account_already_opened}
      end

      def apply(
            %Account{} = account,
            %AccountOpened{
              account_uuid: account_uuid,
              initial_balance: initial_balance
            }
          ) do
        %Account{
          account
          | uuid: account_uuid,
            current_balance: initial_balance
        }
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
