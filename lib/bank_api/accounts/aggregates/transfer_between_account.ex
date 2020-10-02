defmodule BankAPI.Accounts.Aggregates.Account.TransferBetweenAccounts do
  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.TransferBetweenAccounts
  alias BankAPI.Accounts.Events.MoneyTransferRequested

  def aggregate do
    quote do
      def execute(
            %Account{
              uuid: account_uuid,
              closed?: true
            },
            %TransferBetweenAccounts{
              account_uuid: account_uuid
            }
          ) do
        {:error, :account_closed}
      end

      def execute(
            %Account{uuid: account_uuid, closed?: false},
            %TransferBetweenAccounts{
              account_uuid: account_uuid,
              destination_account_uuid: destination_account_uuid
            }
          )
          when account_uuid == destination_account_uuid do
        {:error, :transfer_to_same_account}
      end

      def execute(
            %Account{
              uuid: account_uuid,
              closed?: false,
              current_balance: current_balance
            },
            %TransferBetweenAccounts{
              account_uuid: account_uuid,
              transfer_amount: transfer_amount
            }
          )
          when current_balance < transfer_amount do
        {:error, :insufficient_funds}
      end

      def execute(
            %Account{uuid: account_uuid, closed?: false},
            %TransferBetweenAccounts{
              account_uuid: account_uuid,
              transfer_uuid: transfer_uuid,
              transfer_amount: transfer_amount,
              destination_account_uuid: destination_account_uuid
            }
          ) do
        %MoneyTransferRequested{
          transfer_uuid: transfer_uuid,
          source_account_uuid: account_uuid,
          amount: transfer_amount,
          destination_account_uuid: destination_account_uuid
        }
      end

      def execute(
            %Account{},
            %TransferBetweenAccounts{}
          ) do
        {:error, :not_found}
      end

      def apply(
            %Account{} = account,
            %MoneyTransferRequested{}
          ) do
        account
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
