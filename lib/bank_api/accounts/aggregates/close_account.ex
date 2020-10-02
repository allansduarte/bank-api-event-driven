defmodule BankAPI.Accounts.Aggregates.Account.CloseAccount do
  alias BankAPI.Accounts.Aggregates.Account
  alias BankAPI.Accounts.Commands.CloseAccount
  alias BankAPI.Accounts.Events.AccountClosed

  def aggregate do
    quote do
      def execute(
            %Account{uuid: account_uuid, closed?: true},
            %CloseAccount{
              account_uuid: account_uuid
            }
          ) do
        {:error, :account_already_closed}
      end

      def execute(
            %Account{uuid: account_uuid, closed?: false},
            %CloseAccount{
              account_uuid: account_uuid
            }
          ) do
        %AccountClosed{
          account_uuid: account_uuid
        }
      end

      def execute(
            %Account{},
            %CloseAccount{}
          ) do
        {:error, :not_found}
      end

      def apply(
            %Account{uuid: account_uuid} = account,
            %AccountClosed{
              account_uuid: account_uuid
            }
          ) do
        %Account{
          account
          | closed?: true
        }
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
