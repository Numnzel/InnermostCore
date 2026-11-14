class WeaponResourceController : Inventory abstract {

	name resource; // resource name
	bool idleConditions; // conditions needed to enable resource change
	int idleTime; // time needed without changes to start rate change
	int rateTime; // time of rate change (speed of change)
	int rateAmount; // amount of resource changed

	private int timerIdle; // internal timer for starting resource change
	private int timerRate; // internal timer for managing the change rate

	override void DoEffect() {

		super.DoEffect();

		if (!owner) return;

		// If too idle...
		if (idleConditions &&
			timerIdle++ >= idleTime &&
			timerRate++ >= rateTime) {

			if (rateAmount < 0)
				owner.A_TakeInventory(resource, rateAmount);
			if (rateAmount > 0)
				owner.A_GiveInventory(resource, rateAmount);

			timerRate = 0;
		}
	}

	void RestartTimer() {

		timerIdle = 0;
	}

	int GetAmount() {

		if (!owner) return -99999;

		return owner.CountInv(resource);
	}

	bool CheckAmount(int amount) {

		return (GetAmount() >= amount);
	}

	int AddAmount(int amount, bool restart = true) {

		if (!owner) return -99999;

		owner.A_GiveInventory(resource, amount);

		if (restart)
			RestartTimer();

		return GetAmount();
	}

	int RemoveAmount(int amount, bool restart = true) {

		if (!owner) return -99999;

		owner.A_TakeInventory(resource, amount);

		if (restart)
			RestartTimer();

		return GetAmount();
	}

	default {

		inventory.maxamount 1;

		+INVENTORY.UNDROPPABLE;
		+INVENTORY.UNTOSSABLE;
		+INVENTORY.PERSISTENTPOWER;
	}
}
