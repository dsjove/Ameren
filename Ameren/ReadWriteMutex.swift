
import Foundation

/*
 *	Swift does not have threading constructs, yet.
 *	This very simple class provides safe usage of
 *	a pthread mutex using init/deinit, defer, and
 *	no-escaping trailing closures.
 *
 *  Delete this class when Swift has threading in the standard lib
 */
 
public final class ReadWriteMutex {
	private var imp = pthread_rwlock_t()

	public init() {
		pthread_rwlock_init(&imp, nil)
	}
	
	deinit {
		pthread_rwlock_destroy(&imp)
	}
	
	public func reading<T>(_ closure: @noescape () throws -> T) rethrows -> T {
		defer { pthread_rwlock_unlock(&imp) }
		pthread_rwlock_rdlock(&imp)
		return try closure()
	}
	
	public func writing<T>(_ closure: @noescape () throws -> T) rethrows-> T {
		defer { pthread_rwlock_unlock(&imp) }
		pthread_rwlock_wrlock(&imp)
		return try closure()
	}
}
